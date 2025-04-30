class SubjectTable {
  static const String tableName = 'subjects';
  static const String id = 'id';
  static const String name = 'name';
  static const String link = 'link';
  static const String syncAt = "sync_at";

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
    $id INTEGER PRIMARY KEY AUTOINCREMENT,
    $name TEXT NOT NULL,
    $link TEXT NOT NULL,
    $syncAt DATE_TIME NOT NULL,
    )
  ''';
}
