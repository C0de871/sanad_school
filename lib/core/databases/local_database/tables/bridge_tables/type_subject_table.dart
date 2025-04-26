import 'package:sanad_school/core/databases/local_database/tables/type_table.dart';

import '../subject_table.dart';

class TypeSubjectTable {
  static const String table = 'type_subject';
  static const idType = 'id_type';
  static const idSubject = 'id_subject';

  static const String createTableQuery = '''CREATE TABLE $table (
    $idType INTEGER NOT NULL,
    $idSubject INTEGER NOT NULL,
    FOREIGN KEY ($idType) REFERENCES ${TypeTable.tableName} (${TypeTable.id}) ON DELETE CASCADE,
    FOREIGN KEY ($idSubject) REFERENCES ${SubjectTable.tableName} (${SubjectTable.id}) ON DELETE CASCADE
  )
  ''';
}
