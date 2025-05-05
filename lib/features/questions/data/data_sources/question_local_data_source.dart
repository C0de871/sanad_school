import 'dart:convert';
import 'dart:developer';

import '../../../../core/databases/local_database/sql_db.dart';
import '../../../../core/databases/local_database/tables/bridge_tables/question_groups_table.dart';
import '../../../../core/databases/local_database/tables/bridge_tables/tag_question_table.dart';
import '../../../../core/databases/local_database/tables/question_table.dart';
import '../models/question_model.dart';
import '../models/questions_response_model.dart';

class QuestionLocalDataSource {
  final SqlDB database;

  QuestionLocalDataSource({required this.database});

  // Get questions inside the lesson by type
  Future<QuestionsResponseModel> getQuestionsByLessonAndType(int lessonId, int? typeId) async {
    String query = '';
    if (typeId != null) {
      query = '''
        SELECT q.${QuestionTable.id}, q.${QuestionTable.uuid}, 
               q.${QuestionTable.questionGroupId}, q.${QuestionTable.displayOrder} as display_order, 
               q.${QuestionTable.idTypeQuestion} as type_id, 
               q.${QuestionTable.textQuestion} as text_question, 
               q.${QuestionTable.questionPhoto}, q.${QuestionTable.choices}, 
               q.${QuestionTable.rightChoice} as right_choice, 
               q.${QuestionTable.isEdited} as is_edited, 
               q.${QuestionTable.hint}, q.${QuestionTable.hintPhoto} as hint_photo
        FROM ${QuestionTable.tableName} q
        JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
        WHERE qg.${QuestionGroupsTable.lessonId} = $lessonId 
        AND q.${QuestionTable.idTypeQuestion} = $typeId
        ORDER BY q.${QuestionTable.displayOrder}
      ''';
    } else {
      query = '''
        SELECT q.${QuestionTable.id}, q.${QuestionTable.uuid}, 
               q.${QuestionTable.questionGroupId}, q.${QuestionTable.displayOrder} as display_order, 
               q.${QuestionTable.idTypeQuestion} as type_id, 
               q.${QuestionTable.textQuestion} as text_question, 
               q.${QuestionTable.questionPhoto}, q.${QuestionTable.choices}, 
               q.${QuestionTable.rightChoice} as right_choice, 
               q.${QuestionTable.isEdited} as is_edited, 
               q.${QuestionTable.hint}, q.${QuestionTable.hintPhoto} as hint_photo
        FROM ${QuestionTable.tableName} q
        JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
        WHERE qg.${QuestionGroupsTable.lessonId} = $lessonId
        ORDER BY q.${QuestionTable.displayOrder}
      ''';
    }

    List<Map> questions = await database.sqlReadData(query);
    List<Map<String, dynamic>> formattedQuestions = _formatQuestions(questions);
    // log("formattedQuestions: $formattedQuestions");

    final response = {
      QuestionsResponseModel.dataKey: formattedQuestions,
      QuestionsResponseModel.messageKey: 'Questions in Lesson $lessonId with Type $typeId',
      QuestionsResponseModel.statusKey: 200,
    };
    return QuestionsResponseModel.fromMap(response);
  }

  List<Map<String, dynamic>> _formatQuestions(List<Map> questions) {
    return questions.map((q) {
      // log("choices: ${q['choices']}");
      // log("text_question: ${q['text_question']}");
      // log("hint: ${q['hint']}");
      return {
        QuestionModel.idKey: q[QuestionTable.id],
        QuestionModel.uuidKey: q[QuestionTable.uuid],
        QuestionTable.questionGroupId: q[QuestionTable.questionGroupId],
        QuestionTable.displayOrder: q[QuestionTable.displayOrder],
        QuestionModel.typeIdKey: q[QuestionTable.idTypeQuestion],
        QuestionModel.textQuestionKey: q[QuestionTable.textQuestion] != null ? {"ops": jsonDecode(q[QuestionTable.textQuestion])} : null,
        QuestionModel.questionPhotoKey: q[QuestionTable.questionPhoto],
        QuestionModel.choicesKey: q[QuestionTable.choices] != null ? jsonDecode(q[QuestionTable.choices]).map((item) => {"ops": item}).toList() : null,
        QuestionModel.rightChoiceKey: q[QuestionTable.rightChoice],
        QuestionModel.isEditedKey: q[QuestionTable.isEdited],
        QuestionModel.hintKey: q[QuestionTable.hint] != null ? {"ops": jsonDecode(q[QuestionTable.hint])} : null,
        QuestionModel.hintPhotoKey: q[QuestionTable.hintPhoto],
      };
    }).toList();
  }

  // Get all questions inside a tag
  Future<QuestionsResponseModel> getQuestionsByTag(int tagId) async {
    String query = '''
        SELECT q.${QuestionTable.id}, q.${QuestionTable.uuid}, 
               q.${QuestionTable.questionGroupId}, q.${QuestionTable.displayOrder} as display_order, 
               q.${QuestionTable.idTypeQuestion} as type_id, 
               q.${QuestionTable.textQuestion} as text_question, 
               q.${QuestionTable.questionPhoto}, q.${QuestionTable.choices}, 
               q.${QuestionTable.rightChoice} as right_choice, 
               q.${QuestionTable.isEdited} as is_edited, 
               q.${QuestionTable.hint}, q.${QuestionTable.hintPhoto} as hint_photo
        FROM ${QuestionTable.tableName} q
        JOIN ${TagQuestionTable.tableName} tq ON q.${QuestionTable.id} = tq.${TagQuestionTable.idQuestion}
        WHERE tq.${TagQuestionTable.idTag} = $tagId
        ORDER BY q.${QuestionTable.displayOrder}
      ''';

    List<Map> questions = await database.sqlReadData(query);

    List<Map<String, dynamic>> formattedQuestions = _formatQuestions(questions);

    final response = {
      QuestionsResponseModel.dataKey: formattedQuestions,
      QuestionsResponseModel.messageKey: 'Questions in Tag $tagId',
      QuestionsResponseModel.statusKey: 200,
    };
    return QuestionsResponseModel.fromMap(response);
  }
}
