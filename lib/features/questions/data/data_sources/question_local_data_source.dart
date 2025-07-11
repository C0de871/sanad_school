import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:sanad_school/core/databases/local_database/tables/lesson_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/subject_table.dart';
import 'package:sanad_school/features/download/data/model/download_item.dart';

import '../../../../core/databases/local_database/sql_db.dart';
import '../../../../core/databases/local_database/tables/bridge_tables/question_groups_table.dart';
import '../../../../core/databases/local_database/tables/bridge_tables/tag_question_table.dart';
import '../../../../core/databases/local_database/tables/question_table.dart';
import '../../../download/data/model/subject_download.dart';
import '../models/question_model.dart';
import '../models/questions_response_model.dart';

class QuestionLocalDataSource {
  final SqlDB database;

  QuestionLocalDataSource({required this.database});

  // Common SELECT fields to avoid repetition
  static const String _questionSelectFields = '''
    q.${QuestionTable.id}, 
    q.${QuestionTable.uuid}, 
    q.${QuestionTable.questionGroupId}, 
    q.${QuestionTable.displayOrder} as display_order, 
    q.${QuestionTable.idTypeQuestion} as type_id, 
    q.${QuestionTable.textQuestion} as text_question, 
    q.${QuestionTable.questionPhoto}, 
    q.${QuestionTable.choices}, 
    q.${QuestionTable.rightChoice} as right_choice, 
    q.${QuestionTable.isEdited} as is_edited, 
    q.${QuestionTable.hint} as hint,
    q.${QuestionTable.hintPhoto} as hint_photo,
    q.${QuestionTable.note} as note,
    q.${QuestionTable.isAnswered} as is_answered,
    q.${QuestionTable.isCorrected} as is_corrected,
    q.${QuestionTable.isAnsweredCorrectly} as is_answered_correctly,
    q.${QuestionTable.userAnswer} as user_answer,
    qg.${QuestionGroupsTable.isFavorite} as is_favorite,
    qg.${QuestionGroupsTable.answerStatus} as answer_status,
    qg.${QuestionGroupsTable.displayOrder} as group_display_order

  ''';

  // Common JOIN clause
  static const String _questionJoin = '''
    FROM ${QuestionTable.tableName} q
    JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
  ''';

  // Common ORDER BY clause
  static const String _defaultOrderBy = '''
    ORDER BY qg.${QuestionGroupsTable.displayOrder}, q.${QuestionTable.displayOrder}
  ''';

  /// Generic method to build and execute question queries
  Future<QuestionsResponseModel> _executeQuestionQuery({
    required String whereClause,
    required String successMessage,
    String? additionalJoins,
    String orderBy = _defaultOrderBy,
  }) async {
    final query = '''
        SELECT $_questionSelectFields
        $_questionJoin
        ${additionalJoins ?? ''}
        WHERE $whereClause
        $orderBy
      ''';

    final questions = await database.sqlReadData(query);
    final formattedQuestions = _formatQuestions(questions);

    final response = {
      QuestionsResponseModel.dataKey: formattedQuestions,
      QuestionsResponseModel.messageKey: successMessage,
      QuestionsResponseModel.statusKey: 200,
    };

    return QuestionsResponseModel.fromMap(response);
  }

  /// Get questions inside the lesson by type
  Future<QuestionsResponseModel> getQuestionsByLessonAndType(
    int lessonId,
    int? typeId,
  ) async {
    final whereClause =
        typeId != null
            ? 'qg.${QuestionGroupsTable.lessonId} = $lessonId AND q.${QuestionTable.idTypeQuestion} = $typeId'
            : 'qg.${QuestionGroupsTable.lessonId} = $lessonId';

    final message =
        typeId != null
            ? 'Questions in Lesson $lessonId with Type $typeId'
            : 'Questions in Lesson $lessonId';

    return _executeQuestionQuery(
      whereClause: whereClause,
      successMessage: message,
    );
  }

  /// Get all questions inside a tag
  Future<QuestionsResponseModel> getQuestionsByTag(int tagId) async {
    final additionalJoins = '''
      JOIN ${TagQuestionTable.tableName} tq ON q.${QuestionTable.id} = tq.${TagQuestionTable.idQuestion}
    ''';

    final whereClause = 'tq.${TagQuestionTable.idTag} = $tagId';

    return _executeQuestionQuery(
      whereClause: whereClause,
      successMessage: 'Questions in Tag $tagId',
      additionalJoins: additionalJoins,
    );
  }

  /// Get questions from favorite groups by lesson ID and type
  Future<QuestionsResponseModel> getFavoriteGroupsQuestions(
    int lessonId,
    int? typeId,
  ) async {
    final whereClause = _buildLessonTypeWhereClause(
      lessonId,
      typeId,
      'qg.${QuestionGroupsTable.isFavorite} = 1',
    );

    final message = _buildSuccessMessage(
      'Questions from favorite groups in Lesson $lessonId',
      typeId,
    );

    return _executeQuestionQuery(
      whereClause: whereClause,
      successMessage: message,
    );
  }

  /// Get questions from groups with incorrect answers
  Future<QuestionsResponseModel> getIncorrectAnswerGroupsQuestions(
    int lessonId,
    int? typeId,
  ) async {
    final whereClause = _buildLessonTypeWhereClause(
      lessonId,
      typeId,
      'qg.${QuestionGroupsTable.answerStatus} = 0',
    );

    final message = _buildSuccessMessage(
      'Questions from incorrect answer groups in Lesson $lessonId',
      typeId,
    );

    return _executeQuestionQuery(
      whereClause: whereClause,
      successMessage: message,
    );
  }

  /// Get edited questions by lesson ID and type
  Future<QuestionsResponseModel> getEditedQuestionsByLesson(
    int lessonId,
    int? typeId,
  ) async {
    final whereClause = _buildLessonTypeWhereClause(
      lessonId,
      typeId,
      'q.${QuestionTable.isEdited} = 1',
    );

    final message = _buildSuccessMessage(
      'Edited Questions in Lesson $lessonId',
      typeId,
    );

    return _executeQuestionQuery(
      whereClause: whereClause,
      successMessage: message,
    );
  }

  /// Helper method to build where clause for lesson and type filtering
  String _buildLessonTypeWhereClause(
    int lessonId,
    int? typeId,
    String additionalCondition,
  ) {
    final baseCondition =
        'qg.${QuestionGroupsTable.lessonId} = $lessonId AND $additionalCondition';

    return typeId != null
        ? '$baseCondition AND q.${QuestionTable.idTypeQuestion} = $typeId'
        : baseCondition;
  }

  /// Helper method to build success messages
  String _buildSuccessMessage(String baseMessage, int? typeId) {
    return typeId != null ? '$baseMessage with Type $typeId' : baseMessage;
  }

  /// Format questions from database result to model format
  List<Map<String, dynamic>> _formatQuestions(List<Map> questions) {
    return questions.map((q) {
      try {
        return {
          QuestionModel.idKey: q[QuestionTable.id],
          QuestionModel.uuidKey: q[QuestionTable.uuid],
          QuestionTable.questionGroupId: q[QuestionTable.questionGroupId],
          QuestionTable.displayOrder: q[QuestionTable.displayOrder],
          QuestionModel.typeIdKey: q[QuestionTable.idTypeQuestion],
          QuestionModel.textQuestionKey: _parseJsonField(
            q[QuestionTable.textQuestion],
          ),
          QuestionModel.questionPhotoKey: q[QuestionTable.questionPhoto],
          QuestionModel.choicesKey: _parseChoicesField(
            q[QuestionTable.choices],
          ),
          QuestionModel.rightChoiceKey: q[QuestionTable.rightChoice],
          QuestionModel.isEditedKey: q[QuestionTable.isEdited],
          QuestionModel.hintKey: _parseJsonField(q[QuestionTable.hint]),
          QuestionModel.hintPhotoKey: q[QuestionTable.hintPhoto],
          QuestionModel.noteKey: q[QuestionTable.note],
          QuestionModel.isAnsweredKey: _convertToBool(
            q[QuestionTable.isAnswered],
          ),
          QuestionModel.isCorrectedKey: _convertToBool(
            q[QuestionTable.isCorrected],
          ),
          QuestionModel.isAnsweredCorrectlyKey: _convertToBool(
            q[QuestionTable.isAnsweredCorrectly],
          ),
          QuestionModel.userAnswerKey: q[QuestionTable.userAnswer],
          QuestionModel.isFavoriteKey: _convertToBool(
            q[QuestionGroupsTable.isFavorite],
          ),
          QuestionModel.answerStatusKey: _convertToBool(
            q[QuestionGroupsTable.answerStatus],
          ),
        };
      } catch (e) {
        log('Error formatting question ${q[QuestionTable.id]}: $e');
        // Return a minimal valid question object
        return {
          QuestionModel.idKey: q[QuestionTable.id],
          QuestionModel.uuidKey: q[QuestionTable.uuid] ?? '',
          QuestionTable.questionGroupId: q[QuestionTable.questionGroupId],
          QuestionTable.displayOrder: q[QuestionTable.displayOrder] ?? 0,
          QuestionModel.typeIdKey: q[QuestionTable.idTypeQuestion],
          QuestionModel.textQuestionKey: null,
          QuestionModel.questionPhotoKey: null,
          QuestionModel.choicesKey: null,
          QuestionModel.rightChoiceKey: null,
          QuestionModel.isEditedKey: false,
          QuestionModel.hintKey: null,
          QuestionModel.hintPhotoKey: null,
          QuestionModel.noteKey: null,
          QuestionModel.isFavoriteKey: false,
          QuestionModel.answerStatusKey: false,
          QuestionModel.isAnsweredKey: false,
          QuestionModel.isCorrectedKey: false,
          QuestionModel.isAnsweredCorrectlyKey: false,
        };
      }
    }).toList();
  }

  /// Helper method to parse JSON fields safely
  Map<String, dynamic>? _parseJsonField(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return null;

    try {
      return {"ops": jsonDecode(jsonString)};
    } catch (e) {
      log('Error parsing JSON field: $e');
      return null;
    }
  }

  /// Helper method to parse choices field safely
  List<Map<String, dynamic>>? _parseChoicesField(String? choicesString) {
    if (choicesString == null || choicesString.isEmpty) return null;

    try {
      final decoded = jsonDecode(choicesString);
      if (decoded is List) {
        return decoded
            .map((item) => {"ops": item})
            .toList()
            .cast<Map<String, dynamic>>();
      }
      return null;
    } catch (e) {
      log('Error parsing choices field: $e');
      return null;
    }
  }

  /// Helper method to convert integer to boolean safely
  bool _convertToBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    return false;
  }

  /// Create error response
  QuestionsResponseModel _createErrorResponse(String message) {
    final response = {
      QuestionsResponseModel.dataKey: <Map<String, dynamic>>[],
      QuestionsResponseModel.messageKey: message,
      QuestionsResponseModel.statusKey: 500,
    };
    return QuestionsResponseModel.fromMap(response);
  }

  /// Toggle question favorite status
  Future<bool> toggleQuestionFavorite(int questionId, bool isFavorite) async {
    return _toggleQuestionGroupProperty(
      questionId,
      QuestionGroupsTable.isFavorite,
      isFavorite,
      'Error toggling question favorite',
    );
  }

  /// Toggle question incorrect answer status
  Future<bool> toggleQuestionIncorrectAnswer(
    int questionId,
    bool answerStatus,
  ) async {
    return _toggleQuestionGroupProperty(
      questionId,
      QuestionGroupsTable.answerStatus,
      answerStatus,
      'Error toggling question answer status',
    );
  }

  /// Generic method to toggle question group properties
  Future<bool> _toggleQuestionGroupProperty(
    int questionId,
    String property,
    bool value,
    String errorMessage,
  ) async {
    try {
      // Get the question group ID
      final groupId = await _getQuestionGroupId(questionId);
      if (groupId == null) return false;

      // Update the group's property
      final updateGroupQuery = '''
        UPDATE ${QuestionGroupsTable.tableName}
        SET $property = ${value ? 1 : 0}
        WHERE ${QuestionGroupsTable.id} = $groupId
      ''';

      await database.sqlUpdateData(updateGroupQuery);
      return true;
    } catch (e) {
      log('$errorMessage: $e');
      return false;
    }
  }

  /// Get question group ID for a given question
  Future<int?> _getQuestionGroupId(int questionId) async {
    try {
      final query = '''
        SELECT ${QuestionTable.questionGroupId}
        FROM ${QuestionTable.tableName}
        WHERE ${QuestionTable.id} = $questionId
      ''';

      final result = await database.sqlReadData(query);
      if (result.isEmpty) return null;

      return result[0][QuestionTable.questionGroupId] as int?;
    } catch (e) {
      log('Error getting question group ID: $e');
      return null;
    }
  }

  /// Save a note for a question
  Future<bool> saveQuestionNote(int questionId, String note) async {
    return _updateQuestionField(
      questionId,
      QuestionTable.note,
      note,
      'Error saving question note',
    );
  }

  /// Update question answered status
  Future<bool> updateQuestionAnswered(
    int questionId,
    bool isAnswered,
    int? userAnswer,
  ) async {
    return _updateTwoQuestionFields(
      questionId,
      QuestionTable.isAnswered,
      isAnswered ? 1 : 0,
      QuestionTable.userAnswer,
      userAnswer,
      'Error updating question answered status',
    );
  }

  /// Update question corrected status
  Future<bool> updateQuestionCorrected(int questionId, bool isCorrected) async {
    return _updateQuestionField(
      questionId,
      QuestionTable.isCorrected,
      isCorrected ? 1 : 0,
      'Error updating question corrected status',
    );
  }

  /// Update question answered correctly status
  Future<bool> updateQuestionAnsweredCorrectly(
    int questionId,
    bool isAnsweredCorrectly,
  ) async {
    return _updateQuestionField(
      questionId,
      QuestionTable.isAnsweredCorrectly,
      isAnsweredCorrectly ? 1 : 0,
      'Error updating question answered correctly status',
    );
  }

  /// Save question photo
  Future<bool> saveQuestionPhoto(int questionId, Uint8List photo) async {
    return _updateQuestionField(
      questionId,
      QuestionTable.downloadedQuestionPhoto,
      photo,
      'Error saving question photo',
    );
  }

  /// Save question hint photo
  Future<bool> saveQuestionHintPhoto(int questionId, Uint8List photo) async {
    return _updateQuestionField(
      questionId,
      QuestionTable.downloadedHintPhoto,
      photo,
      'Error saving question hint photo',
    );
  }

  /// Generic method to update question fields
  Future<bool> _updateQuestionField(
    int questionId,
    String field,
    dynamic value,
    String errorMessage,
  ) async {
    try {
      final query = '''
        UPDATE ${QuestionTable.tableName}
        SET $field = $value
        WHERE ${QuestionTable.id} = $questionId
      ''';

      await database.sqlUpdateData(query);
      return true;
    } catch (e) {
      log('$errorMessage: $e');
      return false;
    }
  }

  /// update two question fields
  Future<bool> _updateTwoQuestionFields(
    int questionId,
    String field1,
    dynamic value1,
    String field2,
    dynamic value2,
    String errorMessage,
  ) async {
    try {
      final query = '''
        UPDATE ${QuestionTable.tableName}
        SET $field1 = $value1, $field2 = $value2
        WHERE ${QuestionTable.id} = $questionId
      ''';

      await database.sqlUpdateData(query);
      return true;
    } catch (e) {
      log('$errorMessage: $e');
      return false;
    }
  }

  /// Get question photo
  Future<Uint8List?> getQuestionPhoto(int questionId) async {
    return _getQuestionBlobField(
      questionId,
      QuestionTable.downloadedQuestionPhoto,
      'Error getting question photo',
    );
  }

  /// Get question hint photo
  Future<Uint8List?> getQuestionHintPhoto(int questionId) async {
    return _getQuestionBlobField(
      questionId,
      QuestionTable.downloadedHintPhoto,
      'Error getting question hint photo',
    );
  }

  /// Generic method to get blob fields from questions
  Future<Uint8List?> _getQuestionBlobField(
    int questionId,
    String field,
    String errorMessage,
  ) async {
    try {
      final query = '''
        SELECT $field
        FROM ${QuestionTable.tableName}
        WHERE ${QuestionTable.id} = $questionId 
        AND $field IS NOT NULL
      ''';

      final result = await database.sqlReadData(query);
      if (result.isEmpty) return null;

      return result[0][field] as Uint8List?;
    } catch (e) {
      log('$errorMessage: $e');
      return null;
    }
  }

  /// Get a question's note
  Future<String?> getQuestionNote(int questionId) async {
    try {
      final query = '''
        SELECT ${QuestionTable.note}
        FROM ${QuestionTable.tableName}
        WHERE ${QuestionTable.id} = $questionId
      ''';

      final result = await database.sqlReadData(query);
      if (result.isEmpty) return null;

      return result[0][QuestionTable.note] as String?;
    } catch (e) {
      log('Error getting question note: $e');
      return null;
    }
  }

  /// Get total questions and correctly answered questions count in a subject
  Future<Map<String, int>> getSubjectQuestionStats(int subjectId) async {
    final query = '''
      SELECT 
        COUNT(*) as total_questions,
        SUM(CASE WHEN q.${QuestionTable.isAnswered} = 1 THEN 1 ELSE 0 END) as correctly_answered_questions
    $_questionJoin
      JOIN lessons l ON qg.${QuestionGroupsTable.lessonId} = l.id
      WHERE l.subject_id = $subjectId
    ''';
    final result = await database.sqlReadData(query);
    log(result.toString());
    if (result.isEmpty || result.first['total'] == null) {
      return {'total': 0, 'correct': 0};
    }

    return {
      'total': result.first['total'] as int,
      'correct': result.first['correct'] as int,
    };
  }
}
