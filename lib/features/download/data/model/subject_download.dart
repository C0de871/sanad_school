import 'package:sanad_school/core/databases/local_database/tables/subject_table.dart';

import 'download_item.dart';

class SubjectDownloads {
  final String subjectId;
  final String subjectName;
  final List<DownloadItem> items;

  const SubjectDownloads({
    required this.subjectId,
    required this.subjectName,
    required this.items,
  });

  static const String itemsKey = 'items';

  SubjectDownloads copyWith({
    String? subjectId,
    String? subjectName,
    List<DownloadItem>? items,
  }) {
    return SubjectDownloads(
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      items: items ?? this.items,
    );
  }

  factory SubjectDownloads.fromJson(Map<String, dynamic> data) {
    return SubjectDownloads(
      subjectId: data[SubjectTable.id],
      subjectName: data[SubjectTable.name],
      items:
          (data[itemsKey] as List<Map<String, dynamic>>)
              .map((item) => DownloadItem.fromJson(item))
              .toList(),
    );
  }
}
