import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

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
  Future<QuestionsResponseModel> getQuestionsByLessonAndType(
      int lessonId, int? typeId) async {
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
               q.${QuestionTable.hint} as hint,
               q.${QuestionTable.hintPhoto} as hint_photo,
               q.${QuestionTable.note} as note,
               qg.${QuestionGroupsTable.isFavorite} as is_favorite,
               qg.${QuestionGroupsTable.answerStatus} as answer_status,
               qg.${QuestionGroupsTable.displayOrder} as group_display_order

        FROM ${QuestionTable.tableName} q
        JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
        WHERE qg.${QuestionGroupsTable.lessonId} = $lessonId 
        AND q.${QuestionTable.idTypeQuestion} = $typeId
        ORDER BY qg.${QuestionGroupsTable.displayOrder}, q.${QuestionTable.displayOrder}
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
               q.${QuestionTable.hint} as hint,
               q.${QuestionTable.hintPhoto} as hint_photo,
               q.${QuestionTable.note} as note,
               qg.${QuestionGroupsTable.isFavorite} as is_favorite,
               qg.${QuestionGroupsTable.answerStatus} as answer_status,
               qg.${QuestionGroupsTable.displayOrder} as group_display_order
        FROM ${QuestionTable.tableName} q
        JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
        WHERE qg.${QuestionGroupsTable.lessonId} = $lessonId
        ORDER BY qg.${QuestionGroupsTable.displayOrder}, q.${QuestionTable.displayOrder}
      ''';
    }

    List<Map> questions = await database.sqlReadData(query);
    // log("questions: $questions");
    List<Map<String, dynamic>> formattedQuestions = _formatQuestions(questions);
    log("formattedQuestions: $formattedQuestions");

    final response = {
      QuestionsResponseModel.dataKey: formattedQuestions,
      QuestionsResponseModel.messageKey:
          'Questions in Lesson $lessonId with Type $typeId',
      QuestionsResponseModel.statusKey: 200,
    };
    return QuestionsResponseModel.fromMap(response);
  }

  List<Map<String, dynamic>> _formatQuestions(List<Map> questions) {
    return questions.map((q) {
      return {
        QuestionModel.idKey: q[QuestionTable.id],
        QuestionModel.uuidKey: q[QuestionTable.uuid],
        QuestionTable.questionGroupId: q[QuestionTable.questionGroupId],
        QuestionTable.displayOrder: q[QuestionTable.displayOrder],
        QuestionModel.typeIdKey: q[QuestionTable.idTypeQuestion],
        QuestionModel.textQuestionKey: q[QuestionTable.textQuestion] != null
            ? {"ops": jsonDecode(q[QuestionTable.textQuestion])}
            : null,
        QuestionModel.questionPhotoKey: q[QuestionTable.questionPhoto],
        QuestionModel.choicesKey: q[QuestionTable.choices] != null
            ? jsonDecode(q[QuestionTable.choices])
                .map((item) => {"ops": item})
                .toList()
            : null,
        QuestionModel.rightChoiceKey: q[QuestionTable.rightChoice],
        QuestionModel.isEditedKey: q[QuestionTable.isEdited],
        QuestionModel.hintKey: q[QuestionTable.hint] != null
            ? {"ops": jsonDecode(q[QuestionTable.hint])}
            : null,
        QuestionModel.hintPhotoKey: q[QuestionTable.hintPhoto],
        QuestionModel.noteKey: q[QuestionTable.note],
        QuestionModel.isFavoriteKey:
            q[QuestionGroupsTable.isFavorite] == 1 ? true : false,
        QuestionModel.answerStatusKey:
            q[QuestionGroupsTable.answerStatus] == 1 ? true : false,
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
               q.${QuestionTable.hint} as hint,
               q.${QuestionTable.hintPhoto} as hint_photo,
               q.${QuestionTable.note} as note,
               qg.${QuestionGroupsTable.isFavorite} as is_favorite,
               qg.${QuestionGroupsTable.answerStatus} as answer_status
        FROM ${QuestionTable.tableName} q
        JOIN ${TagQuestionTable.tableName} tq ON q.${QuestionTable.id} = tq.${TagQuestionTable.idQuestion}
        JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
        WHERE tq.${TagQuestionTable.idTag} = $tagId
        ORDER BY q.${QuestionTable.questionGroupId}, q.${QuestionTable.displayOrder}
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

// Method to get questions from favorite groups by lesson ID and type
  Future<QuestionsResponseModel> getFavoriteGroupsQuestions(
      int lessonId, int? typeId) async {
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
             q.${QuestionTable.hint}, q.${QuestionTable.hintPhoto} as hint_photo,
             q.${QuestionTable.note} as note,
             qg.${QuestionGroupsTable.isFavorite} as is_favorite,
             qg.${QuestionGroupsTable.answerStatus} as answer_status
      FROM ${QuestionTable.tableName} q
      JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
      WHERE qg.${QuestionGroupsTable.lessonId} = $lessonId
      AND qg.${QuestionGroupsTable.isFavorite} = 1
      AND q.${QuestionTable.idTypeQuestion} = $typeId
      ORDER BY q.${QuestionTable.questionGroupId}, q.${QuestionTable.displayOrder}
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
             q.${QuestionTable.hint}, q.${QuestionTable.hintPhoto} as hint_photo,
             q.${QuestionTable.note} as note,
             qg.${QuestionGroupsTable.isFavorite} as is_favorite,
             qg.${QuestionGroupsTable.answerStatus} as answer_status
      FROM ${QuestionTable.tableName} q
      JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
      WHERE qg.${QuestionGroupsTable.lessonId} = $lessonId
      AND qg.${QuestionGroupsTable.isFavorite} = 1
      ORDER BY q.${QuestionTable.questionGroupId}, q.${QuestionTable.displayOrder}
    ''';
    }

    List<Map> questions = await database.sqlReadData(query);
    List<Map<String, dynamic>> formattedQuestions = _formatQuestions(questions);

    final response = {
      QuestionsResponseModel.dataKey: formattedQuestions,
      QuestionsResponseModel.messageKey:
          'Questions from favorite groups in Lesson $lessonId${typeId != null ? ' with Type $typeId' : ''}',
      QuestionsResponseModel.statusKey: 200,
    };
    return QuestionsResponseModel.fromMap(response);
  }

// Method to get questions from favorite groups by lesson ID and type
  Future<QuestionsResponseModel> getIncorrectAnswerGroupsQuestions(
      int lessonId, int? typeId) async {
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
             q.${QuestionTable.hint}, q.${QuestionTable.hintPhoto} as hint_photo,
             q.${QuestionTable.note} as note,
             qg.${QuestionGroupsTable.isFavorite} as is_favorite,
             qg.${QuestionGroupsTable.answerStatus} as answer_status
      FROM ${QuestionTable.tableName} q
      JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
      WHERE qg.${QuestionGroupsTable.lessonId} = $lessonId
      AND qg.${QuestionGroupsTable.answerStatus} = 0
      AND q.${QuestionTable.idTypeQuestion} = $typeId
      ORDER BY q.${QuestionTable.questionGroupId}, q.${QuestionTable.displayOrder}
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
             q.${QuestionTable.hint}, q.${QuestionTable.hintPhoto} as hint_photo,
             q.${QuestionTable.note} as note,
             qg.${QuestionGroupsTable.isFavorite} as is_favorite,
             qg.${QuestionGroupsTable.answerStatus} as answer_status
      FROM ${QuestionTable.tableName} q
      JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
      WHERE qg.${QuestionGroupsTable.lessonId} = $lessonId
      AND qg.${QuestionGroupsTable.answerStatus} = 0
      ORDER BY q.${QuestionTable.questionGroupId}, q.${QuestionTable.displayOrder}
    ''';
    }

    List<Map> questions = await database.sqlReadData(query);
    List<Map<String, dynamic>> formattedQuestions = _formatQuestions(questions);

    final response = {
      QuestionsResponseModel.dataKey: formattedQuestions,
      QuestionsResponseModel.messageKey:
          'Questions from favorite groups in Lesson $lessonId${typeId != null ? ' with Type $typeId' : ''}',
      QuestionsResponseModel.statusKey: 200,
    };
    return QuestionsResponseModel.fromMap(response);
  }

// Method to get edited questions by lesson ID and type
  Future<QuestionsResponseModel> getEditedQuestionsByLesson(
      int lessonId, int? typeId) async {
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
             q.${QuestionTable.hint} as hint,
             q.${QuestionTable.hintPhoto} as hint_photo,
             q.${QuestionTable.note} as note,
             qg.${QuestionGroupsTable.isFavorite} as is_favorite,
             qg.${QuestionGroupsTable.answerStatus} as answer_status
      FROM ${QuestionTable.tableName} q
      JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
      WHERE qg.${QuestionGroupsTable.lessonId} = $lessonId
      AND q.${QuestionTable.isEdited} = 1
      AND q.${QuestionTable.idTypeQuestion} = $typeId
      ORDER BY q.${QuestionTable.questionGroupId}, q.${QuestionTable.displayOrder}
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
             q.${QuestionTable.hint} as hint,
             q.${QuestionTable.hintPhoto} as hint_photo,
             q.${QuestionTable.note} as note,
             qg.${QuestionGroupsTable.isFavorite} as is_favorite,
             qg.${QuestionGroupsTable.answerStatus} as answer_status
      FROM ${QuestionTable.tableName} q
      JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
      WHERE qg.${QuestionGroupsTable.lessonId} = $lessonId
      AND q.${QuestionTable.isEdited} = 1
      ORDER BY q.${QuestionTable.questionGroupId}, q.${QuestionTable.displayOrder}
    ''';
    }

    List<Map> questions = await database.sqlReadData(query);
    List<Map<String, dynamic>> formattedQuestions = _formatQuestions(questions);

    final response = {
      QuestionsResponseModel.dataKey: formattedQuestions,
      QuestionsResponseModel.messageKey:
          'Edited Questions in Lesson $lessonId${typeId != null ? ' with Type $typeId' : ''}',
      QuestionsResponseModel.statusKey: 200,
    };
    return QuestionsResponseModel.fromMap(response);
  }

  Future<bool> toggleQuestionFavorite(int questionId, bool isFavorite) async {
    try {
      // Get the question group ID
      String getGroupIdQuery = '''
      SELECT ${QuestionTable.questionGroupId}
      FROM ${QuestionTable.tableName}
      WHERE ${QuestionTable.id} = $questionId
    ''';

      List<Map> result = await database.sqlReadData(getGroupIdQuery);
      if (result.isEmpty) return false;

      int groupId = result[0][QuestionTable.questionGroupId];
      log("groupId: $groupId");

      // Update the group's favorite status
      String updateGroupQuery = '''
      UPDATE ${QuestionGroupsTable.tableName}
      SET ${QuestionGroupsTable.isFavorite} = ${isFavorite ? 1 : 0}
      WHERE ${QuestionGroupsTable.id} = $groupId
    ''';

      await database.sqlUpdateData(updateGroupQuery);
      return true;
    } catch (e) {
      log('Error toggling question favorite: $e');
      return false;
    }
  }

  Future<bool> toggleQuestionIncorrectAnswer(
      int questionId, bool answerStatus) async {
    try {
      // Get the question group ID
      String getGroupIdQuery = '''
      SELECT ${QuestionTable.questionGroupId}
      FROM ${QuestionTable.tableName}
      WHERE ${QuestionTable.id} = $questionId
    ''';

      List<Map> result = await database.sqlReadData(getGroupIdQuery);
      if (result.isEmpty) return false;

      int groupId = result[0][QuestionTable.questionGroupId];

      // Update the group's favorite status
      String updateGroupQuery = '''
      UPDATE ${QuestionGroupsTable.tableName}
      SET ${QuestionGroupsTable.answerStatus} = ${answerStatus ? 1 : 0}
      WHERE ${QuestionGroupsTable.id} = $groupId
    ''';

      await database.sqlUpdateData(updateGroupQuery);
      return true;
    } catch (e) {
      log('Error toggling question favorite: $e');
      return false;
    }
  }

// Method to save a note for a question
  Future<bool> saveQuestionNote(int questionId, String note) async {
    try {
      String query = '''
      UPDATE ${QuestionTable.tableName}
      SET ${QuestionTable.note} = ?
      WHERE ${QuestionTable.id} = $questionId
    ''';

      await database.sqlUpdateData(query, [note]);
      return true;
    } catch (e) {
      log('Error saving question note: $e');
      return false;
    }
  }

  Future<bool> saveQuestionPhoto(int questionId, Uint8List photo) async {
    try {
      String query = '''
      UPDATE ${QuestionTable.tableName}
      SET ${QuestionTable.downloadedQuestionPhoto} = ?
      WHERE ${QuestionTable.id} = $questionId
    ''';
      await database.sqlUpdateData(query, [photo]);
      return true;
    } catch (e) {
      log('Error saving question photo: $e');
      return false;
    }
  }

  Future<bool> saveQuestionHintPhoto(int questionId, Uint8List photo) async {
    try {
      String query = '''
      UPDATE ${QuestionTable.tableName}
      SET ${QuestionTable.downloadedHintPhoto} = ?
      WHERE ${QuestionTable.id} = $questionId
    ''';

      await database.sqlUpdateData(query, [photo]);
      return true;
    } catch (e) {
      log('Error saving question hint photo: $e');
      return false;
    }
  }

  Future<Uint8List?> getQuestionPhoto(int questionId) async {
    try {
      String query = '''
      SELECT ${QuestionTable.downloadedQuestionPhoto}
      FROM ${QuestionTable.tableName}
      WHERE ${QuestionTable.id} = $questionId 
      AND ${QuestionTable.downloadedQuestionPhoto} IS NOT NULL
    ''';

      List<Map> result = await database.sqlReadData(query);
      if (result.isEmpty) return null;

      return result[0][QuestionTable.downloadedQuestionPhoto];
    } catch (e) {
      log('Error getting question photo: $e');
      return null;
    }
  }

  Future<Uint8List?> getQuestionHintPhoto(int questionId) async {
    try {
      String query = '''
      SELECT ${QuestionTable.downloadedHintPhoto}
      FROM ${QuestionTable.tableName}
      WHERE ${QuestionTable.id} = $questionId 
      AND ${QuestionTable.downloadedHintPhoto} IS NOT NULL
    ''';

      List<Map> result = await database.sqlReadData(query);
      if (result.isEmpty) return null;

      return result[0][QuestionTable.downloadedHintPhoto];
    } catch (e) {
      log('Error getting question hint photo: $e');
      return null;
    }
  }

// Method to get a question's note
  Future<String?> getQuestionNote(int questionId) async {
    try {
      String query = '''
      SELECT ${QuestionTable.note}
      FROM ${QuestionTable.tableName}
      WHERE ${QuestionTable.id} = $questionId
    ''';

      List<Map> result = await database.sqlReadData(query);
      if (result.isEmpty) return null;

      return result[0][QuestionTable.note];
    } catch (e) {
      log('Error getting question note: $e');
      return null;
    }
  }
}
