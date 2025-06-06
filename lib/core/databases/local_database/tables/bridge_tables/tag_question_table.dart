import '../question_table.dart';
import '../tag_table.dart';

class TagQuestionTable {
  static String tableName = 'tag_question';
  static String idTag = 'tag_id';
  static String idQuestion = 'question_id';

  static String createTableQuery = '''
    CREATE TABLE $tableName (
      $idTag INTEGER NOT NULL,
      $idQuestion INTEGER NOT NULL,
      FOREIGN KEY ($idTag) REFERENCES ${TagTable.tableName} (${TagTable.id}) ON DELETE CASCADE,
      FOREIGN KEY ($idQuestion) REFERENCES ${QuestionTable.tableName} (${QuestionTable.id}) ON DELETE CASCADE
    )
  ''';
}
