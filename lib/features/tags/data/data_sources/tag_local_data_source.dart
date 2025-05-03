import 'package:sanad_school/features/tags/data/models/tag_response_model.dart';

import '../../../../core/databases/local_database/sql_db.dart';
import '../../../../core/databases/local_database/tables/tag_table.dart';
import '../models/tag_model.dart';

class TagLocalDataSource {
  final SqlDB database;

  TagLocalDataSource({required this.database});

  // Get all tags inside subject
  Future<TagResponseModel> getAllTagsBySubject(int subjectId, int isExam) async {
    String query = '''
        SELECT ${TagTable.id}, ${TagTable.title} as name, ${TagTable.idSubject} as subject_id, ${TagTable.isExam}
        FROM ${TagTable.tableName}
        WHERE ${TagTable.idSubject} = $subjectId AND ${TagTable.isExam} = $isExam
      ''';

    List<Map> tags = await database.sqlReadData(query);

    List<Map<String, dynamic>> formattedTags = tags.map((tag) {
      return {
        TagModel.idKey: tag[TagTable.id],
        TagModel.nameKey: tag[TagTable.title],
        TagModel.subjectIdKey: tag[TagTable.idSubject],
        TagModel.isExamKey: tag[TagTable.isExam],
      };
    }).toList();

    return TagResponseModel(
      tags: formattedTags.map((tag) => TagModel.fromMap(tag)).toList(),
      message: 'Tags in Subject $subjectId',
      status: 200,
    );
  }
}
