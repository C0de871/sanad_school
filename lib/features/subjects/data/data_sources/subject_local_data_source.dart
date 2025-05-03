import 'dart:convert';

import 'package:sanad_school/core/databases/local_database/sql_db.dart';
import 'package:sanad_school/core/databases/local_database/tables/lesson_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/question_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/subject_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/tag_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/bridge_tables/tag_question_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/bridge_tables/question_groups_table.dart';

import 'dart:developer';

import '../../../../core/databases/local_database/tables/type_question_table.dart';
import '../models/subject_model.dart';
import '../models/subject_response_model.dart';
import '../models/subject_sync_model.dart';

abstract class SubjectLocalDataSource {
  Future<void> deleteSubjectData(int subjectId);
  Future<void> insertSubjectData(SubjectSyncModel subjectData);
  Future<void> syncSubjectData(SubjectSyncModel subjectData);
  // Future<List<Map>> getLessonsWithQuestionTypes(int subjectId);
  Future<bool> storeSubjects(SubjectResponseModel response);
  Future<List<SubjectModel>> getAllSubjects();
}

class SubjectLocalDataSourceImpl implements SubjectLocalDataSource {
  final SqlDB database;

  SubjectLocalDataSourceImpl({required this.database});

  @override
  Future<void> deleteSubjectData(int subjectId) async {
    List<Map> relatedQuestions = await database.sqlReadData('''
        SELECT q.${QuestionTable.id} 
        FROM ${QuestionTable.tableName} q
        JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
        JOIN ${LessonTable.tableName} l ON qg.${QuestionGroupsTable.lessonId} = l.${LessonTable.id}
        WHERE l.${LessonTable.subjectId} = $subjectId
      ''');

    // If there are related questions, delete their tag associations
    if (relatedQuestions.isNotEmpty) {
      String questionIds = relatedQuestions.map((q) => q['question_id'].toString()).join(',');
      await database.sqlDeleteData('''
          DELETE FROM ${TagQuestionTable.tableName}
          WHERE ${TagQuestionTable.idQuestion} IN ($questionIds)
        ''');
    }

    // 2. Delete all tags related to this subject
    await database.sqlDeleteData('''
        DELETE FROM ${TagTable.tableName}
        WHERE ${TagTable.idSubject} = $subjectId
      ''');

    // 3. Delete all questions, by first deleting question groups
    // (This will cascade delete questions due to foreign key constraints)
    List<Map> relatedLessons = await database.sqlReadData('''
        SELECT ${LessonTable.id} 
        FROM ${LessonTable.tableName}
        WHERE ${LessonTable.subjectId} = $subjectId
      ''');

    if (relatedLessons.isNotEmpty) {
      String lessonIds = relatedLessons.map((l) => l[LessonTable.id].toString()).join(',');
      await database.sqlDeleteData('''
          DELETE FROM ${QuestionGroupsTable.tableName}
          WHERE ${QuestionGroupsTable.lessonId} IN ($lessonIds)
        ''');
    }

    // 4. Delete all types related to this subject
    //first get all the types related to this subject
    List<Map> types = await database.sqlReadData('''
          SELECT DISTINCT tq.${TypeQuestionTable.id}, tq.${TypeQuestionTable.name}
          FROM ${TypeQuestionTable.tableName} tq
          JOIN ${QuestionTable.tableName} q ON q.${QuestionTable.idTypeQuestion} = tq.${TypeQuestionTable.id}
          JOIN ${QuestionGroupsTable.tableName} qg ON q.${QuestionTable.questionGroupId} = qg.${QuestionGroupsTable.id}
          JOIN ${LessonTable.tableName} l ON qg.${QuestionGroupsTable.lessonId} = l.${LessonTable.id}
          WHERE l.${LessonTable.subjectId} = $subjectId
      ''');

    await database.sqlDeleteData('''
        DELETE FROM ${TypeQuestionTable.tableName}
        WHERE ${TypeQuestionTable.id} IN (${types.map((type) => type[TypeQuestionTable.id]).join(',')})
      ''');
    log("deleted all types related to this subject");

    // 4. Delete all lessons related to this subject
    await database.sqlDeleteData('''
        DELETE FROM ${LessonTable.tableName}
        WHERE ${LessonTable.subjectId} = $subjectId
      ''');

    // 5. Finally, delete the subject itself
    await database.sqlDeleteData('''
        DELETE FROM ${SubjectTable.tableName}
        WHERE ${SubjectTable.id} = $subjectId
      ''');
  }

  @override
  Future<void> insertSubjectData(SubjectSyncModel subjectData) async {
    // 1. Insert subject
    final subjectMap = {
      SubjectTable.id: subjectData.subject.id,
      SubjectTable.name: subjectData.subject.name,
      SubjectTable.link: subjectData.subject.link,
      SubjectTable.icon: subjectData.subject.icon,
      SubjectTable.syncAt: DateTime.now().toIso8601String(),
      SubjectTable.isLocked: subjectData.subject.isLocked ? 1 : 0,
      SubjectTable.numberOfLessons: subjectData.subject.numberOfLessons,
      SubjectTable.numberOfTags: subjectData.subject.numberOfTags,
      SubjectTable.numberOfExams: subjectData.subject.numberOfExams,
      SubjectTable.numberOfQuestions: subjectData.subject.numberOfQuestions,
      SubjectTable.description: subjectData.subject.description,
      SubjectTable.teacher: subjectData.subject.teacher,
    };
    await database.insertData(SubjectTable.tableName, subjectMap);

    // 2. Insert lessons
    for (final lesson in subjectData.lessons) {
      final lessonMap = {
        LessonTable.id: lesson.id,
        LessonTable.title: lesson.title,
        LessonTable.subjectId: lesson.subjectId,
      };
      await database.insertData(LessonTable.tableName, lessonMap);
    }

    // 3. Insert question groups
    for (final group in subjectData.questionGroups) {
      final groupMap = {
        QuestionGroupsTable.id: group.id,
        QuestionGroupsTable.name: group.name,
        QuestionGroupsTable.lessonId: group.lessonId,
        QuestionGroupsTable.displayOrder: group.order,
      };
      await database.insertData(QuestionGroupsTable.tableName, groupMap);
    }

    // 4. Insert types
    for (final type in subjectData.types) {
      final typeMap = {
        TypeQuestionTable.id: type.id,
        TypeQuestionTable.name: type.name,
      };
      await database.insertData(TypeQuestionTable.tableName, typeMap);
    }
    // 5. Insert questions
    for (final question in subjectData.questions) {
      // log("choices without encode: ${question.choices}");
      final questionMap = {
        QuestionTable.id: question.id,
        QuestionTable.textQuestion: jsonEncode(question.textQuestion), // Convert Delta format to string
        QuestionTable.choices: jsonEncode(question.choices),
        QuestionTable.rightChoice: question.rightChoice,
        QuestionTable.isEdited: question.isEdited,
        QuestionTable.hint: jsonEncode(question.hint),
        QuestionTable.uuid: question.uuid,
        QuestionTable.questionGroupId: question.questionGroupId,
        QuestionTable.displayOrder: question.order,
        QuestionTable.idTypeQuestion: question.typeId,
        QuestionTable.questionPhoto: question.questionPhoto,
        QuestionTable.hintPhoto: question.hintPhoto,
      };
      await database.insertData(QuestionTable.tableName, questionMap);
    }

    // 6. Insert tags
    for (final tag in subjectData.tags) {
      final tagMap = {
        TagTable.id: tag.id,
        TagTable.title: tag.title,
        TagTable.isExam: tag.isExam,
        TagTable.idSubject: tag.subjectId,
      };
      await database.insertData(TagTable.tableName, tagMap);
    }

    // 7. Insert question tags
    for (final questionTag in subjectData.questionTags) {
      final questionTagMap = {
        TagQuestionTable.idQuestion: questionTag.questionId,
        TagQuestionTable.idTag: questionTag.tagId,
      };
      await database.insertData(TagQuestionTable.tableName, questionTagMap);
    }
  }

  @override
  Future<void> syncSubjectData(SubjectSyncModel subjectData) async {
    // First delete all existing data for this subject
    await deleteSubjectData(subjectData.subject.id);

    // Then insert the new data
    await insertSubjectData(subjectData);

    log("Successfully synced subject data: ${subjectData.subject.name}");
  }

  // Helper method to encode choices to a string format
  String _encodeChoices(List<List<dynamic>> choices) {
    return choices.map((choice) => choice.toString()).join('|||');
  }

  List<List<String>> _decodeChoices(String encoded) {
    return encoded
        .split('|||') // Split the string into parts
        .map((str) => str
            .replaceAll(RegExp(r'^\[|\]$'), '') // Remove the outer brackets
            .split(', ') // Split the inner list elements
            .map((e) => e.trim()) // Remove extra whitespace
            .toList())
        .toList();
  }

  // Store subjects from API response
  @override
  Future<bool> storeSubjects(SubjectResponseModel response) async {
    await database.deleteData(SubjectTable.tableName, null);

    // Insert all subjects
    for (var subject in response.subjects) {
      await database.insertData(
        SubjectTable.tableName,
        {
          SubjectTable.id: subject.id,
          SubjectTable.name: subject.name,
          SubjectTable.icon: subject.icon,
          SubjectTable.link: subject.link,
          SubjectTable.syncAt: DateTime.now().toIso8601String(),
          SubjectTable.isLocked: subject.isLocked ? 1 : 0,
          SubjectTable.numberOfLessons: subject.numberOfLessons,
          SubjectTable.numberOfTags: subject.numberOfTags,
          SubjectTable.numberOfExams: subject.numberOfExams,
          SubjectTable.numberOfQuestions: subject.numberOfQuestions,
          SubjectTable.description: subject.description,
          SubjectTable.teacher: subject.teacher,
        },
      );
    }
    return true;
  }

  // Get all subjects from database
  @override
  Future<List<SubjectModel>> getAllSubjects() async {
    final List<Map<String, dynamic>> response = await database.readData(SubjectTable.tableName);

    return response.map((subjectMap) {
      return SubjectModel(
        id: subjectMap[SubjectTable.id],
        name: subjectMap[SubjectTable.name],
        icon: subjectMap[SubjectTable.icon],
        link: subjectMap[SubjectTable.link],
        numberOfLessons: subjectMap[SubjectTable.numberOfLessons],
        numberOfTags: subjectMap[SubjectTable.numberOfTags],
        numberOfExams: subjectMap[SubjectTable.numberOfExams],
        numberOfQuestions: subjectMap[SubjectTable.numberOfQuestions],
        isLocked: subjectMap[SubjectTable.isLocked] == 1,
        teacher: subjectMap[SubjectTable.teacher],
        description: subjectMap[SubjectTable.description],
      );
    }).toList();
  }
}
