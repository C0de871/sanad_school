
// ==================== REPOSITORY ====================
import '../../data/model/subject_download.dart';

abstract class DownloadRepository {
  Future<void> initialize();
  Future<void> startSubjectDownloads({
    required String subjectId,
    required String subjectName,
    required List<Map<String, String>> imageUrls,
  });
  Future<void> pauseItem(String itemId);
  Future<void> resumeItem(String itemId);
  Future<void> cancelItem(String itemId);
  Future<void> retryItem(String itemId);
  Future<void> pauseSubject(String subjectId);
  Future<void> resumeSubject(String subjectId);
  Future<void> cancelSubject(String subjectId);
  Future<void> pauseAll();
  Future<void> resumeAll();
  Future<void> cancelAll();
  Stream<List<SubjectDownloads>> get downloadsStream;
  Stream<String?> get errorStream;
  void dispose();
}
