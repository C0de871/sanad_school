class SubjectTable {
  static const String tableName = 'subjects';
  static const String id = 'id';
  static const String name = 'name';
  static const String link = 'link';
  static const String syncAt = "sync_at";
  static const String isLocked = "is_locked";
  static const String numberOfLessons = "number_of_lessons";
  static const String numberOfTags = "number_of_tags";
  static const String numberOfExams = "number_of_exams";
  static const String numberOfQuestions = "number_of_questions";
  static const String description = "description";
  static const String teacher = "teacher";
  static const String icon = "icon";
  static const String isSynced = "is_synced";
  static const String lightColorCode = "light_color_code";
  static const String darkColorCode = "dark_color_code";

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
    $id INTEGER PRIMARY KEY AUTOINCREMENT,
    $name TEXT NOT NULL,
    $link TEXT ,
    $syncAt TEXT ,
    $isLocked INTEGER NOT NULL,
    $numberOfLessons INTEGER NOT NULL,
    $numberOfTags INTEGER NOT NULL,
    $numberOfExams INTEGER NOT NULL,
    $numberOfQuestions INTEGER NOT NULL,
    $description TEXT NOT NULL,
    $teacher TEXT NOT NULL,
    $icon TEXT NOT NULL,
    $isSynced INTEGER DEFAULT 0,
    $lightColorCode TEXT,
    $darkColorCode TEXT
    )
  ''';
}
