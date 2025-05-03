import 'package:sanad_school/core/databases/local_database/tables/subject_table.dart';

class TagTable {
  static const String id = 'id';
  static const String title = 'name';
  static const String isExam = 'is_exam';
  static const String idSubject = "subject_id";

  static const String tableName = 'tag';

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $title TEXT NOT NULL,
      $isExam INTEGER NOT NULL,
      $idSubject INTEGER NOT NULL,
      FOREIGN KEY ($idSubject) REFERENCES ${SubjectTable.tableName} (${SubjectTable.id}) ON DELETE CASCADE
    )
    ''';
}
