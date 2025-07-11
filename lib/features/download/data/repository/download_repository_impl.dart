import 'dart:async';
import 'dart:io';

import '../../domain/download_service/download_service.dart';
import '../../domain/repository/download_repository.dart';
import '../../enums/item_status.dart';
import '../download_service/flutter_download_service.dart';
import '../model/download_item.dart';
import '../model/subject_download.dart';

class DownloadRepositoryImpl implements DownloadRepository {
  final DownloadService _downloadService;
  final StreamController<List<SubjectDownloads>> _downloadsController =
      StreamController<List<SubjectDownloads>>.broadcast();
  final StreamController<String?> _errorController =
      StreamController<String?>.broadcast();

  List<SubjectDownloads> _subjects = [];
  final Map<String, String> _downloadQueue = {}; // itemId -> subjectId

  DownloadRepositoryImpl(this._downloadService);

  @override
  Stream<List<SubjectDownloads>> get downloadsStream =>
      _downloadsController.stream;

  @override
  Stream<String?> get errorStream => _errorController.stream;

  @override
  Future<void> initialize() async {
    try {
      await _downloadService.initialize();
      _downloadService.registerProgressCallback(_onDownloadProgress);
    } catch (e) {
      _errorController.add(e.toString());
    }
  }

  @override
  Future<void> startSubjectDownloads({
    required String subjectId,
    required String subjectName,
    required SubjectDownloads subject,
  }) async {
    try {
      final downloadItems =
          imageUrls.map((imageData) {
            final itemId =
                '${subjectId}_${DateTime.now().millisecondsSinceEpoch}_${imageUrls.indexOf(imageData)}';
            return DownloadItem(
              photoId: itemId,
              url: imageData['url']!,
              fileName: imageData['fileName']!,
              subjectId: subjectId,
            );
          }).toList();

      final subjectDownloads = SubjectDownloads(
        subjectId: subjectId,
        subjectName: subjectName,
        items: downloadItems,
      );

      _subjects = [..._subjects, subjectDownloads];
      _downloadsController.add(_subjects);

      // Start downloading the first item
      await _startNextDownload(subjectId);
    } catch (e) {
      _errorController.add(e.toString());
    }
  }

  Future<void> _startNextDownload(String subjectId) async {
    try {
      final subject = _subjects.firstWhere((s) => s.subjectId == subjectId);
      final nextItem = subject.items.firstWhere(
        (item) => item.status == DownloadItemStatus.enqueued,
        orElse:
            () =>
                DownloadItem(photoId: '', url: '', fileName: '', subjectId: ''),
      );

      if (nextItem.photoId.isEmpty) return;

      final baseDir = await _downloadService.getDownloadDirectory();
      final saveDir = Directory('${baseDir.path}/$subjectId');

      if (!(await saveDir.exists())) {
        await saveDir.create(recursive: true);
      }

      final taskId = await _downloadService.enqueueDownload(
        url: nextItem.url,
        savedDir: saveDir.path,
        fileName: nextItem.fileName,
        showNotification: true,
        openFileFromNotification: false,
        saveInPublicStorage: false,
      );

      _downloadQueue[nextItem.photoId] = subjectId;
      _updateItemStatus(
        nextItem.photoId,
        DownloadItemStatus.running,
        taskId: taskId,
      );
    } catch (e) {
      _errorController.add("Download failed: $e");
    }
  }

  void _onDownloadProgress(
    String taskId,
    DownloadTaskStatus status,
    int progress,
  ) {
    final subjects =
        _subjects.map((subject) {
          final items =
              subject.items.map((item) {
                if (item.taskId == taskId) {
                  final newStatus = _mapDownloadStatus(status);
                  final updatedItem = item.copyWith(
                    status: newStatus,
                    progress: progress,
                  );

                  // Start next download if this one completed
                  if (newStatus == DownloadItemStatus.complete ||
                      newStatus == DownloadItemStatus.failed ||
                      newStatus == DownloadItemStatus.paused ||
                      newStatus == DownloadItemStatus.canceled) {
                    Future.delayed(
                      Duration.zero,
                      () => _startNextDownload(subject.subjectId),
                    );
                  }

                  return updatedItem;
                }
                return item;
              }).toList();

          return SubjectDownloads(
            subjectId: subject.subjectId,
            subjectName: subject.subjectName,
            items: items,
          );
        }).toList();

    _subjects = subjects;
    _downloadsController.add(_subjects);
  }

  void _updateItemStatus(
    String itemId,
    DownloadItemStatus status, {
    String? taskId,
  }) {
    final subjects =
        _subjects.map((subject) {
          final items =
              subject.items.map((item) {
                if (item.photoId == itemId) {
                  return item.copyWith(status: status, taskId: taskId);
                }
                return item;
              }).toList();

          return SubjectDownloads(
            subjectId: subject.subjectId,
            subjectName: subject.subjectName,
            items: items,
          );
        }).toList();

    _subjects = subjects;
    _downloadsController.add(_subjects);
  }

  DownloadItemStatus _mapDownloadStatus(DownloadTaskStatus status) {
    switch (status) {
      case DownloadTaskStatus.enqueued:
        return DownloadItemStatus.enqueued;
      case DownloadTaskStatus.running:
        return DownloadItemStatus.running;
      case DownloadTaskStatus.complete:
        return DownloadItemStatus.complete;
      case DownloadTaskStatus.failed:
        return DownloadItemStatus.failed;
      case DownloadTaskStatus.canceled:
        return DownloadItemStatus.canceled;
      case DownloadTaskStatus.paused:
        return DownloadItemStatus.paused;
    }
  }

  @override
  Future<void> pauseItem(String itemId) async {
    try {
      final item = _findItemById(itemId);
      if (item?.taskId != null) {
        await _downloadService.pauseDownload(item!.taskId!);
      }
    } catch (e) {
      _errorController.add(e.toString());
    }
  }

  @override
  Future<void> resumeItem(String itemId) async {
    try {
      final item = _findItemById(itemId);
      if (item?.taskId != null) {
        await _downloadService.resumeDownload(item!.taskId!);
      }
    } catch (e) {
      _errorController.add(e.toString());
    }
  }

  @override
  Future<void> cancelItem(String itemId) async {
    try {
      final item = _findItemById(itemId);
      if (item?.taskId != null) {
        await _downloadService.cancelDownload(item!.taskId!);
      }
    } catch (e) {
      _errorController.add(e.toString());
    }
  }

  @override
  Future<void> retryItem(String itemId) async {
    try {
      final item = _findItemById(itemId);
      if (item != null) {
        final directory = await _downloadService.getDownloadDirectory();
        final taskId = await _downloadService.enqueueDownload(
          url: item.url,
          savedDir: '${directory.path}/${item.subjectId}',
          fileName: item.fileName,
          showNotification: true,
          openFileFromNotification: false,
        );
        _updateItemStatus(
          item.photoId,
          DownloadItemStatus.running,
          taskId: taskId,
        );
      }
    } catch (e) {
      _errorController.add(e.toString());
    }
  }

  @override
  Future<void> pauseSubject(String subjectId) async {
    try {
      final subject = _subjects.firstWhere((s) => s.subjectId == subjectId);
      for (final item in subject.items) {
        if ((item.status == DownloadItemStatus.running ||
                item.status == DownloadItemStatus.enqueued) &&
            item.taskId != null) {
          await _downloadService.pauseDownload(item.taskId!);
        }
      }
    } catch (e) {
      _errorController.add(e.toString());
    }
  }

  @override
  Future<void> resumeSubject(String subjectId) async {
    try {
      final subject = _subjects.firstWhere((s) => s.subjectId == subjectId);
      for (final item in subject.items) {
        if (item.status == DownloadItemStatus.paused && item.taskId != null) {
          await _downloadService.resumeDownload(item.taskId!);
        }
      }
    } catch (e) {
      _errorController.add(e.toString());
    }
  }

  @override
  Future<void> cancelSubject(String subjectId) async {
    try {
      final subject = _subjects.firstWhere((s) => s.subjectId == subjectId);
      for (final item in subject.items) {
        if (item.taskId != null) {
          await _downloadService.cancelDownload(item.taskId!);
        }
      }
    } catch (e) {
      _errorController.add(e.toString());
    }
  }

  @override
  Future<void> pauseAll() async {
    for (final subject in _subjects) {
      await pauseSubject(subject.subjectId);
    }
  }

  @override
  Future<void> resumeAll() async {
    for (final subject in _subjects) {
      await resumeSubject(subject.subjectId);
    }
  }

  @override
  Future<void> cancelAll() async {
    for (final subject in _subjects) {
      await cancelSubject(subject.subjectId);
    }
  }

  DownloadItem? _findItemById(String itemId) {
    for (final subject in _subjects) {
      for (final item in subject.items) {
        if (item.photoId == itemId) return item;
      }
    }
    return null;
  }

  @override
  void dispose() {
    _downloadsController.close();
    _errorController.close();
    if (_downloadService is FlutterDownloadService) {
      (_downloadService).dispose();
    }
  }
}
