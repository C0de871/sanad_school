import 'package:sanad_school/core/databases/local_database/tables/subject_table.dart';

class LessonTable {
  static const String id = 'id';
  static const String title = 'title';
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";
  static const String idSubject = "id_subject";

  static const String tableName = 'lesson';

  static const String createTableQuery = '''
    CREATE TABLE $tableName(
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $title TEXT,
      $createdAt TEXT NOT NULL,
      $updatedAt TEXT NOT NULL,
      $idSubject INTEGER NOT NULL,
      FOREIGN KEY ($idSubject) REFERENCES ${SubjectTable.tableName} (${SubjectTable.id}) ON DELETE CASCADE
    )
  ''';

  // Future<List<Map<String, dynamic>>> getAllLessons() async {
  //   final SqlDB db = SqlDB();
  //   List<Map<String, dynamic>> response = await db.sqlReadData(

  //   );
  //   return response;
  // }
}
