class TypeTable {
  static const String id = "id";
  static const String name = "name";
  
  static const String tableName = "type";

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $name TEXT NOT NULL
    )
  ''';
}
