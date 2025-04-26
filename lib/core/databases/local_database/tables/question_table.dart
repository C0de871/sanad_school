import 'lesson_table.dart';
import 'photo_table.dart';
import 'type_question_table.dart';
import 'user_table.dart';

class QuestionTable {
  static const String id = "id";
  static const String textQuestion = "text_question";
  static const String choices = "choices";
  static const String rightChoice = "right_choice";
  static const String isEdited = "is_edited";
  static const String hint = "hint";
  static const String photoHint = "photo_hint";
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";
  static const String idLesson = "id_lesson";
  static const String idTypeQuestion = "id_type_question";
  static const String idPhoto = "id_photo";
  static const String idUser = "id_user";

  static const String tableName = "questions";

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT, 
      $textQuestion TEXT, 
      $choices TEXT, 
      $rightChoice INTEGER,   
      $isEdited INTEGER, 
      $hint TEXT, 
      $photoHint TEXT,
      $createdAt TEXT NOT NULL, 
      $updatedAt TEXT NOT NULL,
      $idLesson INTEGER NOT NULL,
      $idTypeQuestion INTEGER UNIQUE NOT NULL,
      $idPhoto INTEGER,
      $idUser INTEGER NOT NULL,
      FOREIGN KEY ($idLesson) REFERENCES ${LessonTable.tableName} (${LessonTable.id}) ON DELETE CASCADE,
      FOREIGN KEY ($idTypeQuestion) REFERENCES ${TypeQuestionTable.tableName} (${TypeQuestionTable.id}) ON DELETE CASCADE,
      FOREIGN KEY ($idPhoto) REFERENCES ${PhotoTable.tableName} (${PhotoTable.id}) ON DELETE CASCADE,
      FOREIGN KEY ($idUser) REFERENCES ${UserTable.tableName} (${UserTable.id}) ON DELETE CASCADE
    )
  ''';
}
