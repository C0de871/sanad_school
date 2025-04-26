class TypeQuestionTable {
  static const String id = "id";
  static const String name = "name";
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";

  static const String tableName = "type_question";

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $name TEXT NOT NULL,
      $createdAt TEXT NOT NULL,
      $updatedAt TEXT NOT NULL
    )
  ''';
}
