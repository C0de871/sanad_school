import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class VideoDownloadService {
  static final VideoDownloadService _instance = VideoDownloadService._internal();
  factory VideoDownloadService() => _instance;
  
  // A simpler approach: use a polling timer to check download status
  final Map<String, Timer> _progressTimers = {};
  final Map<String, Function(double)> _progressCallbacks = {};
  final Map<String, String> _videoIdToTaskId = {}; // Map video IDs to task IDs

  VideoDownloadService._internal() {
    _initializeDownloader();
  }

  // Track download status
  final Map<String, bool> _downloadStatus = {};

  void _initializeDownloader() async {
    try {
      log('Initializing download service');
      await FlutterDownloader.initialize(debug: true);
      
      // Cleanup any incomplete tasks on startup
      _cleanupIncompleteTasks();
      
      log('Download service initialized successfully');
    } catch (e) {
      log('Error initializing downloader: $e');
    }
  }
  
  // Clean up any incomplete tasks from previous sessions
  Future<void> _cleanupIncompleteTasks() async {
    try {
      final tasks = await FlutterDownloader.loadTasks();
      if (tasks != null) {
        for (var task in tasks) {
          if (task.status != DownloadTaskStatus.complete) {
            await FlutterDownloader.remove(
              taskId: task.taskId, 
              shouldDeleteContent: true
            );
            log('Removed incomplete task: ${task.taskId}');
          }
        }
      }
    } catch (e) {
      log('Error cleaning up incomplete tasks: $e');
    }
  }

  Future<Directory?> _createDownloadDirectory() async {
    try {
      Directory? directory;
      if (Platform.isAndroid) {
        // Use the app's private external storage directory for reliability
        directory = await getExternalStorageDirectory();
      } else {
        // Fallback for iOS or other platforms
        directory = await getApplicationDocumentsDirectory();
      }
      if (directory != null && !await directory.exists()) {
        await directory.create(recursive: true);
      }
      return directory;
    } catch (e) {
      log('Error creating download directory: $e');
      return null;
    }
  }

  Future<String?> get _localPath async {
    final directory = await _createDownloadDirectory();
    return directory?.path;
  }

  Future<String> getVideoPath({
    required String videoId,
    required String className,
    required String subjectName,
    required String teacherName,
    required String unit,
  }) async {
    final path = await _localPath;
    if (path == null) {
      throw Exception('Could not get local path');
    }
    return '$path/$className/$subjectName/$teacherName/$unit/$videoId.mp4';
  }

  Future<bool> isVideoDownloaded({
    required String videoId,
    required String className,
    required String subjectName,
    required String teacherName,
    required String unit,
  }) async {
    try {
      final path = await getVideoPath(
        videoId: videoId,
        className: className,
        subjectName: subjectName,
        teacherName: teacherName,
        unit: unit,
      );
      final file = File(path);
      final exists = await file.exists();
      
      // Double check file size to make sure it's not empty
      if (exists) {
        final fileSize = await file.length();
        return fileSize > 0;
      }
      return false;
    } catch (e) {
      log('Error checking if video is downloaded: $e');
      return false;
    }
  }

  Future<bool> _checkAndRequestPermissions() async {
    if (Platform.isAndroid) {
      // Android 13+ (API 33)
      if (await Permission.storage.isDenied) {
        await Permission.storage.request();
      }
      if (await Permission.manageExternalStorage.isDenied) {
        await Permission.manageExternalStorage.request();
      }
      if (await Permission.videos.isDenied) {
        await Permission.videos.request();
      }
      // Check if any are still denied
      if (await Permission.storage.isGranted ||
          await Permission.manageExternalStorage.isGranted ||
          await Permission.videos.isGranted) {
        return true;
      }
      return false;
    }
    // For iOS or other platforms, return true (or handle accordingly)
    return true;
  }
  
  // Start a timer to poll download status
  void _startProgressTracker(String videoId, String taskId, Function(double) onProgressUpdate) {
    // Cancel any existing timer
    _stopProgressTracker(videoId);
    
    // Create a new timer that polls every 500ms
    _progressTimers[videoId] = Timer.periodic(Duration(milliseconds: 500), (timer) async {
      try {
        final tasks = await FlutterDownloader.loadTasks();
        if (tasks == null) {
          return;
        }
        
        // Find the task
        final task = tasks.firstWhere(
          (t) => t.taskId == taskId,
          orElse: () => null as DownloadTask
        );
        
        if (task == null) {
          // Task not found - maybe was removed
          log('Task not found: $taskId');
          onProgressUpdate(0.0);
          _stopProgressTracker(videoId);
          return;
        }
        
        switch (task.status) {
          case DownloadTaskStatus.running:
            // Task is running - update progress
            onProgressUpdate(task.progress / 100);
            break;
            
          case DownloadTaskStatus.complete:
            // Task is complete - update progress and stop tracker
            onProgressUpdate(1.0);
            _downloadStatus[videoId] = true;
            _stopProgressTracker(videoId);
            log('Download completed: $videoId');
            break;
            
          case DownloadTaskStatus.failed:
          case DownloadTaskStatus.canceled:
            // Task failed or was canceled - send 0 progress and stop tracker
            onProgressUpdate(0.0);
            _stopProgressTracker(videoId);
            log('Download failed or canceled: $videoId');
            break;
            
          default:
            // Other states (enqueued, paused) - just update progress
            onProgressUpdate(task.progress / 100);
            break;
        }
      } catch (e) {
        log('Error polling download status: $e');
        // In case of error, stop the timer and notify
        onProgressUpdate(0.0);
        _stopProgressTracker(videoId);
      }
    });
  }
  
  // Stop tracking progress for a video
  void _stopProgressTracker(String videoId) {
    final timer = _progressTimers[videoId];
    if (timer != null && timer.isActive) {
      timer.cancel();
      _progressTimers.remove(videoId);
    }
    _progressCallbacks.remove(videoId);
    _videoIdToTaskId.remove(videoId);
  }
  
  // Cancel all active downloads for a video ID
  Future<void> _cancelPreviousDownloads(String videoId) async {
    try {
      // Stop the progress tracker
      _stopProgressTracker(videoId);
      
      // Cancel any tasks in progress
      if (_videoIdToTaskId.containsKey(videoId)) {
        await FlutterDownloader.cancel(taskId: _videoIdToTaskId[videoId]!);
      }
      
      // Also check for any other tasks that might be downloading this video
      final tasks = await FlutterDownloader.loadTasks();
      if (tasks != null) {
        for (var task in tasks) {
          if (task.filename == '$videoId.mp4') {
            await FlutterDownloader.cancel(taskId: task.taskId);
          }
        }
      }
    } catch (e) {
      log('Error canceling downloads: $e');
    }
  }

  Future<void> downloadVideo({
    required String videoUrl,
    required String videoId,
    required String className,
    required String subjectName,
    required String teacherName,
    required String unit,
    Function(double)? onProgressUpdate,
  }) async {
    try {
      // Cancel any previous downloads
      await _cancelPreviousDownloads(videoId);
      
      // Store callback if provided
      if (onProgressUpdate != null) {
        _progressCallbacks[videoId] = onProgressUpdate;
        
        // Send initial progress update
        onProgressUpdate(0.01);
      }
      
      // Check if video already exists
      final isAlreadyDownloaded = await isVideoDownloaded(
        videoId: videoId,
        className: className,
        subjectName: subjectName,
        teacherName: teacherName,
        unit: unit,
      );
      
      if (isAlreadyDownloaded) {
        log('Video already downloaded: $videoId');
        if (onProgressUpdate != null) {
          onProgressUpdate(1.0); // Indicate completed
        }
        return;
      }

      // Check permissions first
      final hasPermission = await _checkAndRequestPermissions();
      if (!hasPermission) {
        log('Storage permissions not granted');
        onProgressUpdate?.call(0.0);
        throw Exception('Storage permissions not granted');
      }

      // Get and verify download directory
      final basePath = await _localPath;
      if (basePath == null) {
        log('Could not create download directory');
        onProgressUpdate?.call(0.0);
        throw Exception('Could not create download directory');
      }

      // Create the full directory path
      final fullPath = '$basePath/$className/$subjectName/$teacherName/$unit';
      final downloadDir = Directory(fullPath);
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      log('Downloading to: $fullPath');

      // Initialize download status
      _downloadStatus[videoId] = false;

      // Start the download
      final taskId = await FlutterDownloader.enqueue(
        url: videoUrl,
        savedDir: fullPath,
        fileName: '$videoId.mp4',
        showNotification: true,
        openFileFromNotification: false,
        saveInPublicStorage: false,
      );

      if (taskId == null) {
        log('Failed to create download task');
        onProgressUpdate?.call(0.0);
        throw Exception('Failed to create download task');
      }
      
      // Store task ID
      _videoIdToTaskId[videoId] = taskId;
      
      // Start tracking progress
      if (onProgressUpdate != null) {
        _startProgressTracker(videoId, taskId, onProgressUpdate);
      }
      
      log('Download started: videoId=$videoId, taskId=$taskId');

    } catch (e) {
      log('Download error: $e');
      if (onProgressUpdate != null) {
        onProgressUpdate(0.0); // Indicate failure
      }
      throw Exception('Failed to download video: $e');
    }
  }

  Future<void> deleteVideo({
    required String videoId,
    required String className,
    required String subjectName,
    required String teacherName,
    required String unit,
  }) async {
    try {
      // Cancel any ongoing downloads first
      await _cancelPreviousDownloads(videoId);
      
      final path = await getVideoPath(
        videoId: videoId,
        className: className,
        subjectName: subjectName,
        teacherName: teacherName,
        unit: unit,
      );
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        _downloadStatus.remove(videoId);
        log('Video deleted: $videoId');
      }
    } catch (e) {
      log('Failed to delete video: $e');
      throw Exception('Failed to delete video: $e');
    }
  }
  
  // Call this method when disposing the service to clean up resources
  void dispose() {
    try {
      // Cancel all progress timers
      for (var timer in _progressTimers.values) {
        timer.cancel();
      }
      _progressTimers.clear();
      _progressCallbacks.clear();
      _videoIdToTaskId.clear();
    } catch (e) {
      log('Error disposing download service: $e');
    }
  }
} 