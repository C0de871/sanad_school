import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart' hide DownloadTaskStatus;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/download_service/download_service.dart';
import '../../enums/item_status.dart';

class FlutterDownloadService implements DownloadService {
  static const String _portName = 'downloader_send_port';
  final ReceivePort _port = ReceivePort();
  Function(String, DownloadTaskStatus, int)? _progressCallback;

  @override
  Future<void> initialize() async {
    await _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(_downloadCallback);
    await requestPermissions();
  }

  Future<void> _bindBackgroundIsolate() async {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      _portName,
    );

    if (!isSuccess) {
      _unbindBackgroundIsolate();
      await _bindBackgroundIsolate();
      return;
    }

    _port.listen((dynamic data) {
      if (_progressCallback != null) {
        final taskId = (data as List<dynamic>)[0] as String;
        final status = DownloadTaskStatus.fromInt(data[1] as int);
        final progress = data[2] as int;
        _progressCallback!(taskId, status, progress);
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping(_portName);
  }

  @pragma('vm:entry-point')
  static void _downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName(_portName);
    if (send != null) {
      send.send([id, status, progress]);
    } else {
      debugPrint("❌ SendPort not found for $_portName in downloadCallback");
    }
  }

  @override
  Future<String> enqueueDownload({
    required String url,
    required String savedDir,
    required String fileName,
    bool showNotification = true,
    bool openFileFromNotification = false,
    bool saveInPublicStorage = false,
  }) async {
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: savedDir,
      fileName: fileName,
      showNotification: showNotification,
      openFileFromNotification: openFileFromNotification,
      saveInPublicStorage: saveInPublicStorage,
    );
    return taskId ?? '';
  }

  @override
  Future<void> pauseDownload(String taskId) async {
    await FlutterDownloader.pause(taskId: taskId);
  }

  @override
  Future<void> resumeDownload(String taskId) async {
    await FlutterDownloader.resume(taskId: taskId);
  }

  @override
  Future<void> cancelDownload(String taskId) async {
    await FlutterDownloader.cancel(taskId: taskId);
  }

  @override
  void registerProgressCallback(
    Function(String taskId, DownloadTaskStatus status, int progress) callback,
  ) {
    _progressCallback = callback;
  }

  @override
  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
      await Permission.notification.request();
    }
  }

  @override
  Future<Directory> getDownloadDirectory() async {
    return await getExternalStorageDirectory() ??
        await getApplicationDocumentsDirectory();
  }

  void dispose() {
    _unbindBackgroundIsolate();
  }
}
