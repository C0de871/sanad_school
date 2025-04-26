import 'package:sanad_school/core/databases/local_database/tables/city_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/type_table.dart';

class UserTable {
  //!table attributes:
  static const String tableName = "users";
  static const String id = "id";
  static const String firstName = "first_name";
  static const String lastName = "last_name";
  static const String fatherName = "father_name";
  static const String school = "school";
  static const String email = "email";
  static const String phone = "phone";
  static const String password = "password";
  static const String isEnabled = "is_enabled";
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";
  static const String idType = 'id_type';
  static const String idCity = 'id_city';

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
    $isEnabled INTEGER NOT NULL,
    $createdAt TEXT NOT NULL,
    $updatedAt TEXT NOT NULL,
    $idType INTEGER NOT NULL,
    $idCity INTEGER NOT NULL,
    FOREIGN KEY ($idType) REFERENCES ${TypeTable.tableName} (${TypeTable.id}) ON DELETE CASCADE,
    FOREIGN KEY ($idCity) REFERENCES ${CityTable.tableName} (${CityTable.id}) ON DELETE CASCADE
    )
    ''';
}
