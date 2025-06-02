import 'dart:developer';

import '../../../../core/databases/local_database/sql_db.dart';
import '../../../../core/databases/local_database/tables/lesson_table.dart';
import '../../../../core/databases/local_database/tables/type_question_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/question_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/bridge_tables/question_groups_table.dart';

import '../../../subject_type/data/models/type_model.dart';
import '../models/lesson_model.dart';
import '../models/lessons_response_model.dart';

class LessonsLocalDataSource {
  final SqlDB database;

  LessonsLocalDataSource({required this.database});
  Future<LessonsResponseModel> getLessonsWithQuestionTypes(
      int subjectId) async {
    // Query to get lessons by subject ID
    String query = '''
      SELECT ${LessonTable.tableName}.${LessonTable.id}, 
             ${LessonTable.tableName}.${LessonTable.title}, 
             ${LessonTable.tableName}.${LessonTable.subjectId}
      FROM ${LessonTable.tableName}
      WHERE ${LessonTable.tableName}.${LessonTable.subjectId} = $subjectId
    ''';

    List<Map> lessons = await database.sqlReadData(query);

    // Get total questions count for the subject
    final subjectQuestionsCount = await _getSubjectQuestionsCount(subjectId);

    // For each lesson, get the question types
    List<Map<String, dynamic>> formattedLessons = [];

    for (var lesson in lessons) {
      // Query to get question types for this lesson
      String typesQuery = '''
        SELECT DISTINCT tq.${TypeQuestionTable.id}, tq.${TypeQuestionTable.name}
        FROM ${TypeQuestionTable.tableName} tq
        JOIN ${QuestionTable.tableName} q ON q.${QuestionTable.idTypeQuestion} = tq.${TypeQuestionTable.id}
        JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
        WHERE qg.${QuestionGroupsTable.lessonId} = ${lesson[LessonTable.id]}
      ''';

      List<Map> types = await database.sqlReadData(typesQuery);

      // Format the lesson with its types
      formattedLessons.add({
        LessonModel.idKey: lesson[LessonTable.id],
        LessonModel.titleKey: lesson[LessonTable.title],
        LessonModel.subjectIdKey: lesson[LessonTable.subjectId],
        LessonModel.questionTypesKey: types
            .map((type) => {
                  TypeModel.idKey: type[TypeQuestionTable.id],
                  TypeModel.nameKey: type[TypeQuestionTable.name],
                })
            .toList(),
      });
    }

    final data = {
      LessonsResponseModel.dataKey: formattedLessons,
      LessonsResponseModel.messageKey: 'Lessons in Subject $subjectId',
      LessonsResponseModel.statusKey: 200,
      LessonsResponseModel.totalQuestionsKey:
          subjectQuestionsCount[LessonsResponseModel.totalQuestionsKey],
      LessonsResponseModel.totalAnsweredQuestionsKey:
          subjectQuestionsCount[LessonsResponseModel.totalAnsweredQuestionsKey],
    };

    return LessonsResponseModel.fromMap(data);
  }

  /// Helper method to get subject questions count
  Future<Map<String, int>> _getSubjectQuestionsCount(int subjectId) async {
    try {
      final query = '''
      SELECT 
        COUNT(*) as ${LessonsResponseModel.totalQuestionsKey},
        SUM(CASE WHEN q.${QuestionTable.isAnswered} = 1 THEN 1 ELSE 0 END) as ${LessonsResponseModel.totalAnsweredQuestionsKey}
      FROM ${QuestionTable.tableName} q
      JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
      WHERE qg.${QuestionGroupsTable.lessonId} IN (
        SELECT ${LessonTable.id}
        FROM ${LessonTable.tableName}
        WHERE ${LessonTable.subjectId} = $subjectId
      )
    ''';

      final result = await database.sqlReadData(query);
      log(result.toString());
      if (result.isEmpty) {
        return {
          LessonsResponseModel.totalQuestionsKey: 0,
          LessonsResponseModel.totalAnsweredQuestionsKey: 0,
        };
      }

      final row = result[0];
      return {
        LessonsResponseModel.totalQuestionsKey:
            row[LessonsResponseModel.totalQuestionsKey] as int? ?? 0,
        LessonsResponseModel.totalAnsweredQuestionsKey:
            row[LessonsResponseModel.totalAnsweredQuestionsKey] as int? ?? 0,
      };
    } catch (e) {
      log('Error getting subject questions count: $e');
      return {
        LessonsResponseModel.totalQuestionsKey: 0,
        LessonsResponseModel.totalAnsweredQuestionsKey: 0,
      };
    }
  }

  // Method to get lessons that contain favorite question groups
  Future<LessonsResponseModel> getLessonsWithFavoriteGroups(
      int subjectId) async {
    // Query to get lessons that have favorite groups
    String query = '''
    SELECT DISTINCT ${LessonTable.tableName}.${LessonTable.id}, 
           ${LessonTable.tableName}.${LessonTable.title}, 
           ${LessonTable.tableName}.${LessonTable.subjectId}
    FROM ${LessonTable.tableName}
    JOIN ${QuestionGroupsTable.tableName} ON ${QuestionGroupsTable.tableName}.${QuestionGroupsTable.lessonId} = ${LessonTable.tableName}.${LessonTable.id}
    WHERE ${LessonTable.tableName}.${LessonTable.subjectId} = $subjectId
    AND ${QuestionGroupsTable.tableName}.${QuestionGroupsTable.isFavorite} = 1
  ''';

    List<Map> lessons = await database.sqlReadData(query);

    final subjectQuestionsCount = await _getSubjectQuestionsCount(subjectId);

    // For each lesson, get the question types
    List<Map<String, dynamic>> formattedLessons = [];

    for (var lesson in lessons) {
      // Query to get question types for this lesson
      String typesQuery = '''
      SELECT DISTINCT tq.${TypeQuestionTable.id}, tq.${TypeQuestionTable.name}
      FROM ${TypeQuestionTable.tableName} tq
      JOIN ${QuestionTable.tableName} q ON q.${QuestionTable.idTypeQuestion} = tq.${TypeQuestionTable.id}
      JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
      WHERE qg.${QuestionGroupsTable.lessonId} = ${lesson[LessonTable.id]}
      AND qg.${QuestionGroupsTable.isFavorite} = 1
    ''';

      List<Map> types = await database.sqlReadData(typesQuery);

      // Format the lesson with its types
      formattedLessons.add({
        LessonModel.idKey: lesson[LessonTable.id],
        LessonModel.titleKey: lesson[LessonTable.title],
        LessonModel.subjectIdKey: lesson[LessonTable.subjectId],
        LessonModel.questionTypesKey: types
            .map((type) => {
                  TypeModel.idKey: type[TypeQuestionTable.id],
                  TypeModel.nameKey: type[TypeQuestionTable.name],
                })
            .toList(),
      });
    }

    final data = {
      LessonsResponseModel.dataKey: formattedLessons,
      LessonsResponseModel.messageKey:
          'Lessons with favorite groups in Subject $subjectId',
      LessonsResponseModel.statusKey: 200,
      LessonsResponseModel.totalQuestionsKey:
          subjectQuestionsCount[LessonsResponseModel.totalQuestionsKey],
      LessonsResponseModel.totalAnsweredQuestionsKey:
          subjectQuestionsCount[LessonsResponseModel.totalAnsweredQuestionsKey],
    };
    return LessonsResponseModel.fromMap(data);
  }

  // Method to get lessons that contain favorite question groups
  Future<LessonsResponseModel> getLessonsWithIncorrectAnswerGroups(
      int subjectId) async {
    // Query to get lessons that have favorite groups
    String query = '''
    SELECT DISTINCT ${LessonTable.tableName}.${LessonTable.id}, 
           ${LessonTable.tableName}.${LessonTable.title}, 
           ${LessonTable.tableName}.${LessonTable.subjectId}
    FROM ${LessonTable.tableName}
    JOIN ${QuestionGroupsTable.tableName} ON ${QuestionGroupsTable.tableName}.${QuestionGroupsTable.lessonId} = ${LessonTable.tableName}.${LessonTable.id}
    WHERE ${LessonTable.tableName}.${LessonTable.subjectId} = $subjectId
    AND ${QuestionGroupsTable.tableName}.${QuestionGroupsTable.answerStatus} = 0
  ''';

    List<Map> lessons = await database.sqlReadData(query);
    final subjectQuestionsCount = await _getSubjectQuestionsCount(subjectId);

    // For each lesson, get the question types
    List<Map<String, dynamic>> formattedLessons = [];

    for (var lesson in lessons) {
      // Query to get question types for this lesson
      String typesQuery = '''
      SELECT DISTINCT tq.${TypeQuestionTable.id}, tq.${TypeQuestionTable.name}
      FROM ${TypeQuestionTable.tableName} tq
      JOIN ${QuestionTable.tableName} q ON q.${QuestionTable.idTypeQuestion} = tq.${TypeQuestionTable.id}
      JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
      WHERE qg.${QuestionGroupsTable.lessonId} = ${lesson[LessonTable.id]}
      AND qg.${QuestionGroupsTable.answerStatus} = 0
    ''';

      List<Map> types = await database.sqlReadData(typesQuery);

      // Format the lesson with its types
      formattedLessons.add({
        LessonModel.idKey: lesson[LessonTable.id],
        LessonModel.titleKey: lesson[LessonTable.title],
        LessonModel.subjectIdKey: lesson[LessonTable.subjectId],
        LessonModel.questionTypesKey: types
            .map((type) => {
                  TypeModel.idKey: type[TypeQuestionTable.id],
                  TypeModel.nameKey: type[TypeQuestionTable.name],
                })
            .toList(),
      });
    }

    final data = {
      LessonsResponseModel.dataKey: formattedLessons,
      LessonsResponseModel.messageKey:
          'Lessons with favorite groups in Subject $subjectId',
      LessonsResponseModel.statusKey: 200,
      LessonsResponseModel.totalQuestionsKey:
          subjectQuestionsCount[LessonsResponseModel.totalQuestionsKey],
      LessonsResponseModel.totalAnsweredQuestionsKey:
          subjectQuestionsCount[LessonsResponseModel.totalAnsweredQuestionsKey],
    };
    return LessonsResponseModel.fromMap(data);
  }

// Method to get lessons that contain edited questions
  Future<LessonsResponseModel> getLessonsWithEditedQuestions(
      int subjectId) async {
    // Query to get lessons that have edited questions
    String query = '''
    SELECT DISTINCT ${LessonTable.tableName}.${LessonTable.id}, 
           ${LessonTable.tableName}.${LessonTable.title}, 
           ${LessonTable.tableName}.${LessonTable.subjectId}
    FROM ${LessonTable.tableName}
    JOIN ${QuestionGroupsTable.tableName} ON ${QuestionGroupsTable.tableName}.${QuestionGroupsTable.lessonId} = ${LessonTable.tableName}.${LessonTable.id}
    JOIN ${QuestionTable.tableName} ON ${QuestionTable.tableName}.${QuestionTable.questionGroupId} = ${QuestionGroupsTable.tableName}.${QuestionGroupsTable.id}
    WHERE ${LessonTable.tableName}.${LessonTable.subjectId} = $subjectId
    AND ${QuestionTable.tableName}.${QuestionTable.isEdited} = 1
  ''';

    List<Map> lessons = await database.sqlReadData(query);
    final subjectQuestionsCount = await _getSubjectQuestionsCount(subjectId);

    // For each lesson, get the question types
    List<Map<String, dynamic>> formattedLessons = [];

    for (var lesson in lessons) {
      // Query to get question types for this lesson, filtering for edited questions
      String typesQuery = '''
      SELECT DISTINCT tq.${TypeQuestionTable.id}, tq.${TypeQuestionTable.name}
      FROM ${TypeQuestionTable.tableName} tq
      JOIN ${QuestionTable.tableName} q ON q.${QuestionTable.idTypeQuestion} = tq.${TypeQuestionTable.id}
      JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
      WHERE qg.${QuestionGroupsTable.lessonId} = ${lesson[LessonTable.id]}
      AND q.${QuestionTable.isEdited} = 1
    ''';

      List<Map> types = await database.sqlReadData(typesQuery);

      // Format the lesson with its types
      formattedLessons.add({
        LessonModel.idKey: lesson[LessonTable.id],
        LessonModel.titleKey: lesson[LessonTable.title],
        LessonModel.subjectIdKey: lesson[LessonTable.subjectId],
        LessonModel.questionTypesKey: types
            .map((type) => {
                  TypeModel.idKey: type[TypeQuestionTable.id],
                  TypeModel.nameKey: type[TypeQuestionTable.name],
                })
            .toList(),
      });
    }

    final data = {
      LessonsResponseModel.dataKey: formattedLessons,
      LessonsResponseModel.messageKey:
          'Lessons with edited questions in Subject $subjectId',
      LessonsResponseModel.statusKey: 200,
      LessonsResponseModel.totalQuestionsKey:
          subjectQuestionsCount[LessonsResponseModel.totalQuestionsKey],
      LessonsResponseModel.totalAnsweredQuestionsKey:
          subjectQuestionsCount[LessonsResponseModel.totalAnsweredQuestionsKey],
    };
    return LessonsResponseModel.fromMap(data);
  }
}
