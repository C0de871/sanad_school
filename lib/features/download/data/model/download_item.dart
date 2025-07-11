import 'package:sanad_school/core/databases/local_database/tables/subject_table.dart';

import '../../../../core/databases/local_database/tables/question_table.dart';
import '../../enums/item_status.dart';

class DownloadItem {
  final String? id;
  final int questionId;
  final String url;
  final String fileName;
  final int subjectId;
  final DownloadItemStatus status;
  final int progress;
  final String? taskId;

  const DownloadItem({
    this.id,
    required this.questionId,
    required this.url,
    required this.fileName,
    required this.subjectId,
    this.status = DownloadItemStatus.enqueued,
    this.progress = 0,
    this.taskId,
  });
  static const String urlKey = 'url';
  static const String fileNameKey = 'fileName';

  DownloadItem copyWith({
    String? id,
    int? questionId,
    String? url,
    String? fileName,
    int? subjectId,
    DownloadItemStatus? status,
    int? progress,
    String? taskId,
  }) {
    return DownloadItem(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      url: url ?? this.url,
      fileName: fileName ?? this.fileName,
      subjectId: subjectId ?? this.subjectId,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      taskId: taskId ?? this.taskId,
    );
  }

  factory DownloadItem.fromJson(Map<String, dynamic> item) {
    return DownloadItem(
      questionId: item[QuestionTable.id] as int,
      url: item[urlKey] as String,
      fileName: item[fileNameKey] as String,
      subjectId: item[SubjectTable.id] as int,
    );
  }
}
