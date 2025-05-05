import '../../../../core/databases/local_database/sql_db.dart';
import '../../../../core/databases/local_database/tables/lesson_table.dart';
import '../../../../core/databases/local_database/tables/type_question_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/question_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/bridge_tables/question_groups_table.dart';

import 'dart:developer';

import '../../../subject_type/data/models/type_model.dart';
import '../models/lesson_model.dart';
import '../models/lessons_response_model.dart';

class LessonsLocalDataSource {
  final SqlDB database;

  LessonsLocalDataSource({required this.database});

  Future<LessonsResponseModel> getLessonsWithQuestionTypes(int subjectId) async {
    // Query to get lessons by subject ID
    String query = '''
        SELECT ${LessonTable.tableName}.${LessonTable.id}, 
               ${LessonTable.tableName}.${LessonTable.title}, 
               ${LessonTable.tableName}.${LessonTable.subjectId}
        FROM ${LessonTable.tableName}
        WHERE ${LessonTable.tableName}.${LessonTable.subjectId} = $subjectId
      ''';

    List<Map> lessons = await database.sqlReadData(query);

    // For each lesson, get the question types
    List<Map<String, dynamic>> formattedLessons = [];

    for (var lesson in lessons) {
      // log(lesson.toString());
      // Query to get question types for this lesson
      // This would need to be adapted based on your schema
      String typesQuery = '''
          SELECT DISTINCT tq.${TypeQuestionTable.id}, tq.${TypeQuestionTable.name}
          FROM ${TypeQuestionTable.tableName} tq
          JOIN ${QuestionTable.tableName} q ON q.${QuestionTable.idTypeQuestion} = tq.${TypeQuestionTable.id}
          JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
          WHERE qg.${QuestionGroupsTable.lessonId} = ${lesson[LessonTable.id]}
        ''';

      List<Map> types = await database.sqlReadData(typesQuery);
      // log(types.toString());

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
    };
    return LessonsResponseModel.fromMap(data);
  }
}
