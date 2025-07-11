
// ==================== DOWNLOAD SERVICE ====================
import 'dart:io';

import '../../enums/item_status.dart';

abstract class DownloadService {
  Future<void> initialize();
  Future<String> enqueueDownload({
    required String url,
    required String savedDir,
    required String fileName,
    bool showNotification = true,
    bool openFileFromNotification = false,
    bool saveInPublicStorage = false,
  });
  Future<void> pauseDownload(String taskId);
  Future<void> resumeDownload(String taskId);
  Future<void> cancelDownload(String taskId);
  void registerProgressCallback(Function(String taskId, DownloadTaskStatus status, int progress) callback);
  Future<void> requestPermissions();
  Future<Directory> getDownloadDirectory();
}