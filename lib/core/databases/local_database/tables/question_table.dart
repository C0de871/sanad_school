import 'lesson_table.dart';
import 'type_question_table.dart';

class QuestionTable {
  static const String id = "id";
  static const String textQuestion = "text_question";
  static const String choices = "choices";
  static const String rightChoice = "right_choice";
  static const String isEdited = "is_edited";
  static const String hint = "hint";
  static const String idLesson = "lesson_id";
  static const String idTypeQuestion = "type_id";
  static const String questionPhoto = "question_photo";
  static const String hintPhoto = "hint_photo";

  static const String tableName = "questions";

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT, 
      $textQuestion TEXT, 
      $choices TEXT, 
      $rightChoice INTEGER,   
      $isEdited TINY_INT 1, //TODO CHEKC THE TINY INT SYNTAX AND THE DATE TIME SYNTAX IN SUBJECT
      $hint TEXT, 
      $hintPhoto TEXT,
      $idLesson INTEGER NOT NULL,
      $idTypeQuestion INTEGER UNIQUE NOT NULL,
      $questionPhoto TEXT,
      FOREIGN KEY ($idLesson) REFERENCES ${LessonTable.tableName} (${LessonTable.id}) ON DELETE CASCADE,
      FOREIGN KEY ($idTypeQuestion) REFERENCES ${TypeQuestionTable.tableName} (${TypeQuestionTable.id}) ON DELETE CASCADE,
    )
  ''';
}
