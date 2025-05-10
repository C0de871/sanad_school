import 'type_question_table.dart';

class QuestionTable {
  static const String id = "id";
  static const String textQuestion = "text_question";
  static const String choices = "choices";
  static const String rightChoice = "right_choice";
  static const String isEdited = "is_edited";
  static const String hint = "hint";
  static const String uuid = "uuid";
  static const String questionGroupId = "question_group_id";
  static const String displayOrder = 'display_order';
  static const String idTypeQuestion = "type_id";
  static const String questionPhoto = "question_photo";
  static const String hintPhoto = "hint_photo";
  static const String note = "note";
  static const String downloadedHintPhoto = "downloaded_hint_photo";
  static const String downloadedQuestionPhoto = "downloaded_question_photo";

  static const String tableName = "questions";

  // Note: SQLite does not have a strict BOOLEAN type. Use INTEGER (0 or 1).
  // If you want DATETIME, use TEXT or INTEGER and handle formatting in Dart.

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT, 
      $textQuestion TEXT, 
      $choices TEXT, 
      $rightChoice INTEGER,   
      $isEdited INTEGER, 
      $hint TEXT, 
      $hintPhoto TEXT,
      $uuid TEXT,
      $questionGroupId INTEGER NOT NULL,
      $displayOrder INTEGER,
      $idTypeQuestion INTEGER NOT NULL,
      $questionPhoto TEXT,
      $note TEXT,
      $downloadedHintPhoto BLOB,
      $downloadedQuestionPhoto BLOB,
      FOREIGN KEY ($questionGroupId) REFERENCES question_groups(id) ON DELETE CASCADE,
      FOREIGN KEY ($idTypeQuestion) REFERENCES ${TypeQuestionTable.tableName} (${TypeQuestionTable.id}) ON DELETE CASCADE
    )
  ''';
}
