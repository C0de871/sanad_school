import 'package:sanad_school/core/databases/local_database/tables/type_table.dart';

class StudentTable {
  //!table attributes:
  static const String tableName = "student";
  static const String id = "id";
  static const String firstName = "first_name";
  static const String lastName = "last_name";
  static const String fatherName = "father_name";
  static const String school = "school";
  static const String email = "email";
  static const String phone = "phone";
  static const String password = "password";
  static const String idType = 'type_id';
  static const String city = 'city';

  //!create table query:
  static const String createTableQuery = '''
    CREATE TABLE $tableName (
    $id INTEGER PRIMARY KEY AUTOINCREMENT,
    $firstName TEXT NOT NULL,
    $lastName TEXT NOT NULL,
    $fatherName TEXT NOT NULL,
    $school TEXT NOT NULL,
    $email TEXT NOT NULL,
    $phone TEXT NOT NULL,
    $password TEXT NOT NULL,
    $idType INTEGER NOT NULL,
    $city INTEGER NOT NULL,
    FOREIGN KEY ($idType) REFERENCES ${TypeTable.tableName} (${TypeTable.id}) ON DELETE CASCADE
    )
    ''';
}
