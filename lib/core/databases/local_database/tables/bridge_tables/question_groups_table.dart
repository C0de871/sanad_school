class QuestionGroupsTable {
  static const String tableName = 'question_groups';

  static const String id = 'id';
  static const String name = 'name';
  static const String lessonId = 'lesson_id';
  static const String displayOrder = 'display_order';
  static const String isFavorite = "is_favorite";
  static const String answerStatus = "answer_status";

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      $id INTEGER PRIMARY KEY,
      $name TEXT NOT NULL,
      $lessonId INTEGER NOT NULL,
      $displayOrder INTEGER,
      $isFavorite INTEGER,
      $answerStatus INTEGER,
      FOREIGN KEY ($lessonId) REFERENCES lessons(id) ON DELETE CASCADE
    )
  ''';
}
