import 'package:sanad_school/core/databases/local_database/tables/subject_table.dart';

class LessonTable {
  static const String id = 'id';
  static const String title = 'title';
  static const String subjectId = "subject_id";

  static const String tableName = 'lessons';

  static const String createTableQuery = '''
    CREATE TABLE $tableName(
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $title TEXT,
      $subjectId INTEGER NOT NULL,
      FOREIGN KEY ($subjectId) REFERENCES ${SubjectTable.tableName} (${SubjectTable.id}) ON DELETE CASCADE
    )
  ''';

  // Future<List<Map<String, dynamic>>> getAllLessons() async {
  //   final SqlDB db = SqlDB();
  //   List<Map<String, dynamic>> response = await db.sqlReadData(

  //   );
  //   return response;
  // }
}
