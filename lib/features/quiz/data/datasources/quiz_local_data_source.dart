import 'dart:convert';
import 'dart:developer';

import 'package:sanad_school/features/tags/data/models/tag_response_model.dart';

import '../../../../core/databases/local_database/sql_db.dart';
import '../../../../core/databases/local_database/tables/bridge_tables/question_groups_table.dart';
import '../../../../core/databases/local_database/tables/bridge_tables/tag_question_table.dart';
import '../../../../core/databases/local_database/tables/lesson_table.dart';
import '../../../../core/databases/local_database/tables/question_table.dart';
import '../../../../core/databases/local_database/tables/tag_table.dart';
import '../../../../core/databases/local_database/tables/type_question_table.dart';
import '../../../../core/databases/params/params.dart';
import '../../../lessons/data/models/lesson_model.dart';
import '../../../lessons/data/models/lessons_response_model.dart';
import '../../../lessons/data/models/question_type_model.dart';
import '../../../questions/data/models/question_model.dart';
import '../../../questions/data/models/questions_response_model.dart';

class QuizLocalDataSource {
  final SqlDB database;
  QuizLocalDataSource({required this.database});

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

  //!quiz service:
  // Main function to get question groups based on multiple filters
  Future<QuestionsResponseModel> getFilteredQuestions({
    required QuizFilterParams params,
  }) async {
    // Build query conditions based on provided filters
    List<String> conditions = [];

    // Always filter by subject
    conditions.add('l.${LessonTable.subjectId} = ${params.subjectId}');

    // Add lesson filter if provided
    if (params.lessonIds.isNotEmpty) {
      conditions.add(
          'qg.${QuestionGroupsTable.lessonId} IN (${params.lessonIds.join(',')})');
    }

    // For type and tag filters, we need to use EXISTS clauses because we need to check
    // if ANY question in the group matches these criteria

    // Type filter
    if (params.typeIds.isNotEmpty) {
      conditions.add('''
        EXISTS (
          SELECT 1 FROM ${QuestionTable.tableName} subq
          WHERE subq.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
          AND subq.${QuestionTable.idTypeQuestion} IN (${params.typeIds.join(',')})
        )
      ''');
    }

    // Tag filter
    if (params.tagIds.isNotEmpty) {
      conditions.add('''
        EXISTS (
          SELECT 1 FROM ${QuestionTable.tableName} subq
          JOIN ${TagQuestionTable.tableName} tq ON subq.${QuestionTable.id} = tq.${TagQuestionTable.idQuestion}
          WHERE subq.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
          AND tq.${TagQuestionTable.idTag} IN (${params.tagIds.join(',')})
        )
      ''');
    }

    // Combine all conditions
    String whereClause = conditions.join(' AND ');

    // Build the final query to get all question groups that match the criteria
    String query = '''
      SELECT DISTINCT qg.${QuestionGroupsTable.id}
      FROM ${QuestionGroupsTable.tableName} qg
      JOIN ${LessonTable.tableName} l ON qg.${QuestionGroupsTable.lessonId} = l.${LessonTable.id}
      WHERE $whereClause
    ''';

    // Execute the query to get matching question group IDs
    List<Map> matchingGroups = await database.sqlReadData(query);
    List<int> groupIds = matchingGroups
        .map<int>((group) => group[QuestionGroupsTable.id] as int)
        .toList();

    if (groupIds.isEmpty) {
      // No matching question groups found
      final response = {
        QuestionsResponseModel.dataKey: [],
        QuestionsResponseModel.messageKey:
            'No questions match the selected criteria',
        QuestionsResponseModel.statusKey: 200,
      };
      return QuestionsResponseModel.fromMap(response);
    }

    // Now get all questions that belong to these matching groups
    String questionsQuery = '''
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
      WHERE q.${QuestionTable.questionGroupId} IN (${groupIds.join(',')})
      ORDER BY q.${QuestionTable.questionGroupId}, q.${QuestionTable.displayOrder}
    ''';

    List<Map> questions = await database.sqlReadData(questionsQuery);
    List<Map<String, dynamic>> formattedQuestions = _formatQuestions(questions);

    final response = {
      QuestionsResponseModel.dataKey: formattedQuestions,
      QuestionsResponseModel.messageKey: 'Filtered questions',
      QuestionsResponseModel.statusKey: 200,
    };
    return QuestionsResponseModel.fromMap(response);
  }

  // Get available lessons based on selected types and tags
  Future<LessonsResponseModel> getAvailableLessons({
    required GetAvailableLessonsParams params,
  }) async {
    List<String> conditions = [];

    // Always filter by subject
    conditions.add('l.${LessonTable.subjectId} = ${params.subjectId}');

    // Type filter
    if (params.selectedTypeIds.isNotEmpty) {
      conditions.add('''
        EXISTS (
          SELECT 1 FROM ${QuestionTable.tableName} q
          JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
          WHERE qg.${QuestionGroupsTable.lessonId} = l.${LessonTable.id}
          AND q.${QuestionTable.idTypeQuestion} IN (${params.selectedTypeIds.join(',')})
        )
      ''');
    }

    // Tag filter
    if (params.selectedTagIds.isNotEmpty) {
      conditions.add('''
        EXISTS (
          SELECT 1 FROM ${QuestionTable.tableName} q
          JOIN ${TagQuestionTable.tableName} tq ON q.${QuestionTable.id} = tq.${TagQuestionTable.idQuestion}
          JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
          WHERE qg.${QuestionGroupsTable.lessonId} = l.${LessonTable.id}
          AND tq.${TagQuestionTable.idTag} IN (${params.selectedTagIds.join(',')})
        )
      ''');
    }

    // Combine all conditions
    String whereClause = conditions.join(' AND ');

    String query = '''
      SELECT DISTINCT l.${LessonTable.id}, l.${LessonTable.title}, l.${LessonTable.subjectId}
      FROM ${LessonTable.tableName} l
      WHERE $whereClause
      ORDER BY l.${LessonTable.id}
    ''';

    List<Map> lessons = await database.sqlReadData(query);

    List<Map<String, dynamic>> formattedLessons = lessons
        .map((lesson) => {
              LessonModel.idKey: lesson[LessonTable.id],
              LessonModel.titleKey: lesson[LessonTable.title],
              LessonModel.subjectIdKey: lesson[LessonTable.subjectId],
              // LessonModel.questionTypesKey: lesson[LessonTable.questionTypes],
            })
        .toList();

    log("formatted lesssons: ${formattedLessons.toString()}");

    final response = {
      LessonsResponseModel.dataKey: formattedLessons,
      LessonsResponseModel.messageKey: 'Lessons fetched successfully',
      LessonsResponseModel.statusKey: 200,
    };
    return LessonsResponseModel.fromMap(response);
  }

  // Get available types based on selected lessons and tags
  Future<List<QuestionTypeModel>> getAvailableTypes({
    required GetAvailableTypesParams params,
  }) async {
    List<String> conditions = [];

    // Basic condition to connect tables
    conditions.add('l.${LessonTable.subjectId} = ${params.subjectId}');
    conditions.add('qg.${QuestionGroupsTable.lessonId} = l.${LessonTable.id}');
    conditions.add(
        'q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}');
    conditions
        .add('q.${QuestionTable.idTypeQuestion} = t.${TypeQuestionTable.id}');

    // Lesson filter
    if (params.selectedLessonIds.isNotEmpty) {
      conditions.add(
          'l.${LessonTable.id} IN (${params.selectedLessonIds.join(',')})');
    }

    // Tag filter
    if (params.selectedTagIds.isNotEmpty) {
      conditions.add('''
        EXISTS (
          SELECT 1 FROM ${TagQuestionTable.tableName} tq
          WHERE tq.${TagQuestionTable.idQuestion} = q.${QuestionTable.id}
          AND tq.${TagQuestionTable.idTag} IN (${params.selectedTagIds.join(',')})
        )
      ''');
    }

    // Combine all conditions
    String whereClause = conditions.join(' AND ');

    String query = '''
      SELECT DISTINCT t.${TypeQuestionTable.id}, t.${TypeQuestionTable.name}
      FROM ${TypeQuestionTable.tableName} t
      JOIN ${QuestionTable.tableName} q ON q.${QuestionTable.idTypeQuestion} = t.${TypeQuestionTable.id}
      JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
      JOIN ${LessonTable.tableName} l ON qg.${QuestionGroupsTable.lessonId} = l.${LessonTable.id}
      WHERE $whereClause
      ORDER BY t.${TypeQuestionTable.id}
    ''';

    List<Map> types = await database.sqlReadData(query);

    // return types
    //     .map((type) => {
    //           TypeModel.idKey: type[TypeQuestionTable.id],
    //           TypeModel.nameKey: type[TypeQuestionTable.name],
    //         })
    //     .toList();
    log("formatted types: ${types.toString()}");
    return types
        .map((type) => QuestionTypeModel.fromMap(type as Map<String, dynamic>))
        .toList();
  }

  // Get available tags based on selected lessons and types
  Future<TagResponseModel> getAvailableTags({
    required GetAvailableTagsParams params,
  }) async {
    List<String> conditions = [];

    // Basic condition to connect tables
    conditions.add('l.${LessonTable.subjectId} = ${params.subjectId}');
    conditions.add('qg.${QuestionGroupsTable.lessonId} = l.${LessonTable.id}');
    conditions.add(
        'q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}');
    conditions.add('tq.${TagQuestionTable.idQuestion} = q.${QuestionTable.id}');
    conditions.add('tq.${TagQuestionTable.idTag} = tag.${TagTable.id}');

    // Lesson filter
    if (params.selectedLessonIds.isNotEmpty) {
      conditions.add(
          'l.${LessonTable.id} IN (${params.selectedLessonIds.join(',')})');
    }

    // Type filter
    if (params.selectedTypeIds.isNotEmpty) {
      conditions.add(
          'q.${QuestionTable.idTypeQuestion} IN (${params.selectedTypeIds.join(',')})');
    }

    // Combine all conditions
    String whereClause = conditions.join(' AND ');

    String query = '''
      SELECT DISTINCT tag.${TagTable.id}, tag.${TagTable.title}, tag.${TagTable.idSubject}, tag.${TagTable.isExam}
      FROM ${TagTable.tableName} tag
      JOIN ${TagQuestionTable.tableName} tq ON tq.${TagQuestionTable.idTag} = tag.${TagTable.id}
      JOIN ${QuestionTable.tableName} q ON q.${QuestionTable.id} = tq.${TagQuestionTable.idQuestion}
      JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
      JOIN ${LessonTable.tableName} l ON qg.${QuestionGroupsTable.lessonId} = l.${LessonTable.id}
      WHERE $whereClause
      ORDER BY tag.${TagTable.id}
    ''';

    List<Map> tags = await database.sqlReadData(query);
    log("formatted tags: ${tags.toString()}");

    final response = {
      TagResponseModel.dataKey: tags,
      TagResponseModel.messageKey: 'Tags fetched successfully',
      TagResponseModel.statusKey: 200,
    };
    return TagResponseModel.fromMap(response);

    // return tags
    //     .map((tag) => {
    //           TagModel.idKey: tag[TagTable.id],
    //           TagModel.nameKey: tag[TagTable.title],
    //           TagModel.subjectIdKey: tag[TagTable.idSubject],
    //           TagModel.isExamKey: tag[TagTable.isExam],
    //         })
    //     .toList();
  }

  Future<int> getFilteredQuestionsCounts({
    required QuizFilterParams params,
  }) async {
    // Build query conditions based on provided filters
    List<String> conditions = [];

    // Always filter by subject
    conditions.add('l.${LessonTable.subjectId} = ${params.subjectId}');

    // Add lesson filter if provided
    if (params.lessonIds.isNotEmpty) {
      conditions.add(
          'qg.${QuestionGroupsTable.lessonId} IN (${params.lessonIds.join(',')})');
    }

    // For type and tag filters, we need to use EXISTS clauses because we need to check
    // if ANY question in the group matches these criteria

    // Type filter
    if (params.typeIds.isNotEmpty) {
      conditions.add('''
        EXISTS (
          SELECT 1 FROM ${QuestionTable.tableName} subq
          WHERE subq.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
          AND subq.${QuestionTable.idTypeQuestion} IN (${params.typeIds.join(',')})
        )
      ''');
    }

    // Tag filter
    if (params.tagIds.isNotEmpty) {
      conditions.add('''
        EXISTS (
          SELECT 1 FROM ${QuestionTable.tableName} subq
          JOIN ${TagQuestionTable.tableName} tq ON subq.${QuestionTable.id} = tq.${TagQuestionTable.idQuestion}
          WHERE subq.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
          AND tq.${TagQuestionTable.idTag} IN (${params.tagIds.join(',')})
        )
      ''');
    }

    // Combine all conditions
    String whereClause = conditions.join(' AND ');

    // Build the final query to get all question groups that match the criteria
    String query = '''
      SELECT DISTINCT qg.${QuestionGroupsTable.id}
      FROM ${QuestionGroupsTable.tableName} qg
      JOIN ${LessonTable.tableName} l ON qg.${QuestionGroupsTable.lessonId} = l.${LessonTable.id}
      WHERE $whereClause
    ''';

    // Execute the query to get matching question group IDs
    List<Map> matchingGroups = await database.sqlReadData(query);
    List<int> groupIds = matchingGroups
        .map<int>((group) => group[QuestionGroupsTable.id] as int)
        .toList();

    if (groupIds.isEmpty) {
      return 0;
    }

    // Now get all questions that belong to these matching groups
    String questionsQuery = '''
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
      WHERE q.${QuestionTable.questionGroupId} IN (${groupIds.join(',')})
      ORDER BY q.${QuestionTable.questionGroupId}, q.${QuestionTable.displayOrder}
    ''';

    List<Map> questions = await database.sqlReadData(questionsQuery);
    List<Map<String, dynamic>> formattedQuestions = _formatQuestions(questions);
      log("formatted formattedQuestions.length: ${formattedQuestions.length.toString()}");

    return formattedQuestions.length;
  }
}
