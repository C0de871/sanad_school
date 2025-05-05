import 'dart:convert';
import 'dart:developer';

import 'package:sanad_school/core/databases/local_database/sql_db.dart';
import 'package:sanad_school/core/databases/local_database/tables/bridge_tables/question_groups_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/bridge_tables/tag_question_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/lesson_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/question_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/subject_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/tag_table.dart';
import 'package:sanad_school/features/lessons/data/models/lesson_model.dart';
import 'package:sanad_school/features/questions/data/models/question_model.dart';
import 'package:sanad_school/features/tags/data/models/tag_model.dart';
import 'package:sqflite/sqflite.dart';

import '../models/question_group_model.dart';
import '../models/question_tag_model.dart';
import '../models/subject_model.dart';
import '../models/subject_sync_model.dart';

class SubjectDetailLocalDataSource {
  final SqlDB _db = SqlDB();

  /// Syncs all subject details from the subject sync API response
  Future<void> syncSubjectDetails(SubjectSyncModel syncModel) async {
    // Start a transaction by getting the database
    final database = await _db.db;
    await database?.transaction((txn) async {
      try {
        // Sync subject
        await _syncSubject(syncModel.subject as SubjectModel, txn);

        // Sync lessons
        await _syncLessons(
          syncModel.lessons?.cast<LessonModel>() ?? [],
          syncModel.subject.id,
          txn,
        );

        // Sync question groups
        await _syncQuestionGroups(
          syncModel.questionGroups?.cast<QuestionGroupModel>() ?? [],
          syncModel.subject.id,
          txn,
        );

        // Sync questions
        await _syncQuestions(
          syncModel.questions?.cast<QuestionModel>() ?? [],
          syncModel.subject.id,
          txn,
        );

        // Sync tags
        await _syncTags(
          syncModel.tags?.cast<TagModel>() ?? [],
          syncModel.subject.id,
          txn,
        );

        // Sync question tags
        await _syncQuestionTags(
          syncModel.questionTags?.cast<QuestionTagModel>() ?? [],
          syncModel.subject.id,
          txn,
        );

        // Sync question types
        // await _syncQuestionTypes(
        //   syncModel.types.cast<TypeModel>(),
        //   txn,
        // );

        log("Subject details synced successfully");
      } catch (e) {
        log("Error syncing subject details: $e");
        rethrow;
      }
    });
    // await _db.logAllTables();
  }

  /// Syncs a subject with the local database
  Future<void> _syncSubject(SubjectModel subject, Transaction txn) async {
    final subjectMap = subject.toMap();

    // Check if subject exists
    final existingSubject = await txn.query(
      SubjectTable.tableName,
      where: '${SubjectTable.id} = ?',
      whereArgs: [subject.id],
    );

    if (existingSubject.isNotEmpty) {
      // Update existing subject
      await txn.update(
        SubjectTable.tableName,
        subjectMap,
        where: '${SubjectTable.id} = ?',
        whereArgs: [subject.id],
      );
    } else {
      // Insert new subject
      await txn.insert(SubjectTable.tableName, subjectMap);
    }
  }

  /// Syncs lessons for a subject with the local database
  Future<void> _syncLessons(List<LessonModel> lessons, int subjectId, Transaction txn) async {
    // Get existing lessons for this subject
    final existingLessons = await txn.query(
      LessonTable.tableName,
      where: '${LessonTable.subjectId} = ?',
      whereArgs: [subjectId],
    );

    final existingLessonIds = existingLessons.map<int>((lesson) => lesson[LessonTable.id] as int).toSet();
    final responseLessonIds = lessons.map((lesson) => lesson.id).toSet();

    // Insert or update lessons
    for (final lesson in lessons) {
      final lessonMap = {
        LessonTable.id: lesson.id,
        LessonTable.title: lesson.title,
        LessonTable.subjectId: lesson.subjectId,
      };

      if (existingLessonIds.contains(lesson.id)) {
        // Update existing lesson
        await txn.update(
          LessonTable.tableName,
          lessonMap,
          where: '${LessonTable.id} = ?',
          whereArgs: [lesson.id],
        );
      } else {
        // Insert new lesson
        await txn.insert(LessonTable.tableName, lessonMap);
      }
    }

    // Delete lessons that are in the local database but not in the response
    final lessonsToDelete = existingLessonIds.difference(responseLessonIds);
    for (final id in lessonsToDelete) {
      await txn.delete(
        LessonTable.tableName,
        where: '${LessonTable.id} = ?',
        whereArgs: [id],
      );
    }
  }

  /// Syncs question groups for a subject with the local database
  Future<void> _syncQuestionGroups(
    List<QuestionGroupModel> groups,
    int subjectId,
    Transaction txn,
  ) async {
    // First, get all lesson IDs for this subject
    final lessonRows = await txn.query(
      LessonTable.tableName,
      columns: [LessonTable.id],
      where: '${LessonTable.subjectId} = ?',
      whereArgs: [subjectId],
    );

    final lessonIds = lessonRows.map<int>((row) => row[LessonTable.id] as int).toSet();

    // Get existing question groups for lessons in this subject
    final existingGroups = await txn.rawQuery('''
      SELECT qg.${QuestionGroupsTable.id}
      FROM ${QuestionGroupsTable.tableName} qg
      JOIN ${LessonTable.tableName} l ON qg.${QuestionGroupsTable.lessonId} = l.${LessonTable.id}
      WHERE l.${LessonTable.subjectId} = $subjectId
    ''');

    final existingGroupIds = existingGroups.map<int>((group) => group[QuestionGroupsTable.id] as int).toSet();
    final responseGroupIds = groups.map((group) => group.id).toSet();

    // Insert or update question groups
    for (final group in groups) {
      // Skip if the lesson doesn't belong to this subject
      if (!lessonIds.contains(group.lessonId)) continue;

      final groupMap = {
        QuestionGroupsTable.id: group.id,
        QuestionGroupsTable.name: group.name,
        QuestionGroupsTable.lessonId: group.lessonId,
        QuestionGroupsTable.displayOrder: group.order,
      };

      if (existingGroupIds.contains(group.id)) {
        // Update existing group
        await txn.update(
          QuestionGroupsTable.tableName,
          groupMap,
          where: '${QuestionGroupsTable.id} = ?',
          whereArgs: [group.id],
        );
      } else {
        // Insert new group
        await txn.insert(QuestionGroupsTable.tableName, groupMap);
      }
    }

    // Delete question groups that are in the local database but not in the response
    final groupsToDelete = existingGroupIds.difference(responseGroupIds);
    for (final id in groupsToDelete) {
      await txn.delete(
        QuestionGroupsTable.tableName,
        where: '${QuestionGroupsTable.id} = ?',
        whereArgs: [id],
      );
    }
  }

  /// Syncs questions for a subject with the local database
  Future<void> _syncQuestions(
    List<QuestionModel> questions,
    int subjectId,
    Transaction txn,
  ) async {
    // First, get all question group IDs for this subject
    final questionGroupRows = await txn.rawQuery('''
      SELECT qg.${QuestionGroupsTable.id}
      FROM ${QuestionGroupsTable.tableName} qg
      JOIN ${LessonTable.tableName} l ON qg.${QuestionGroupsTable.lessonId} = l.${LessonTable.id}
      WHERE l.${LessonTable.subjectId} = $subjectId
    ''');

    final questionGroupIds = questionGroupRows.map<int>((row) => row[QuestionGroupsTable.id] as int).toSet();

    // Get existing questions for question groups in this subject
    final existingQuestions = await txn.rawQuery('''
      SELECT q.${QuestionTable.id}
      FROM ${QuestionTable.tableName} q
      WHERE q.${QuestionTable.questionGroupId} IN (
        SELECT qg.${QuestionGroupsTable.id}
        FROM ${QuestionGroupsTable.tableName} qg
        JOIN ${LessonTable.tableName} l ON qg.${QuestionGroupsTable.lessonId} = l.${LessonTable.id}
        WHERE l.${LessonTable.subjectId} = $subjectId
      )
    ''');

    final existingQuestionIds = existingQuestions.map<int>((question) => question[QuestionTable.id] as int).toSet();
    final responseQuestionIds = questions.map((question) => question.id).toSet();

    // Insert or update questions
    for (final question in questions) {
      // Skip if the question group doesn't belong to this subject
      if (question.questionGroupId != null && !questionGroupIds.contains(question.questionGroupId)) continue;

      final questionMap = {
        QuestionTable.id: question.id,
        QuestionTable.textQuestion: jsonEncode(question.textQuestion),
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

      if (existingQuestionIds.contains(question.id)) {
        // Update existing question
        await txn.update(
          QuestionTable.tableName,
          questionMap,
          where: '${QuestionTable.id} = ?',
          whereArgs: [question.id],
        );
      } else {
        // Insert new question
        await txn.insert(QuestionTable.tableName, questionMap);
      }
    }

    // Delete questions that are in the local database but not in the response
    final questionsToDelete = existingQuestionIds.difference(responseQuestionIds);
    for (final id in questionsToDelete) {
      await txn.delete(
        QuestionTable.tableName,
        where: '${QuestionTable.id} = ?',
        whereArgs: [id],
      );
    }
  }

  /// Syncs tags for a subject with the local database
  Future<void> _syncTags(
    List<TagModel> tags,
    int subjectId,
    Transaction txn,
  ) async {
    // Get existing tags for this subject
    final existingTags = await txn.query(
      TagTable.tableName,
      where: '${TagTable.idSubject} = ?',
      whereArgs: [subjectId],
    );

    final existingTagIds = existingTags.map<int>((tag) => tag[TagTable.id] as int).toSet();
    final responseTagIds = tags.where((tag) => tag.subjectId == subjectId).map((tag) => tag.id).toSet();

    // Insert or update tags
    for (final tag in tags) {
      // Skip if the tag doesn't belong to this subject
      if (tag.subjectId != subjectId) continue;

      final tagMap = {
        TagTable.id: tag.id,
        TagTable.title: tag.name,
        TagTable.isExam: tag.isExam ? 1 : 0,
        TagTable.idSubject: tag.subjectId,
      };

      if (existingTagIds.contains(tag.id)) {
        // Update existing tag
        await txn.update(
          TagTable.tableName,
          tagMap,
          where: '${TagTable.id} = ?',
          whereArgs: [tag.id],
        );
      } else {
        // Insert new tag
        await txn.insert(TagTable.tableName, tagMap);
      }
    }

    // Delete tags that are in the local database but not in the response
    final tagsToDelete = existingTagIds.difference(responseTagIds);
    for (final id in tagsToDelete) {
      await txn.delete(
        TagTable.tableName,
        where: '${TagTable.id} = ?',
        whereArgs: [id],
      );
    }
  }

  /// Syncs question tags for a subject with the local database
  Future<void> _syncQuestionTags(
    List<QuestionTagModel> questionTags,
    int subjectId,
    Transaction txn,
  ) async {
    // First, get all question IDs for this subject
    final questionRows = await txn.rawQuery('''
      SELECT q.${QuestionTable.id}
      FROM ${QuestionTable.tableName} q
      WHERE q.${QuestionTable.questionGroupId} IN (
        SELECT qg.${QuestionGroupsTable.id}
        FROM ${QuestionGroupsTable.tableName} qg
        JOIN ${LessonTable.tableName} l ON qg.${QuestionGroupsTable.lessonId} = l.${LessonTable.id}
        WHERE l.${LessonTable.subjectId} = $subjectId
      )
    ''');

    final subjectQuestionIds = questionRows.map<int>((row) => row[QuestionTable.id] as int).toSet();

    // Get all tag IDs for this subject
    final tagRows = await txn.query(
      TagTable.tableName,
      columns: [TagTable.id],
      where: '${TagTable.idSubject} = ?',
      whereArgs: [subjectId],
    );

    final subjectTagIds = tagRows.map<int>((row) => row[TagTable.id] as int).toSet();

    // Get existing question_tag relations for this subject
    final existingQuestionTags = await txn.rawQuery('''
      SELECT tq.${TagQuestionTable.idQuestion}, tq.${TagQuestionTable.idTag}
      FROM ${TagQuestionTable.tableName} tq
      WHERE tq.${TagQuestionTable.idQuestion} IN (
        SELECT q.${QuestionTable.id}
        FROM ${QuestionTable.tableName} q
        WHERE q.${QuestionTable.questionGroupId} IN (
          SELECT qg.${QuestionGroupsTable.id}
          FROM ${QuestionGroupsTable.tableName} qg
          JOIN ${LessonTable.tableName} l ON qg.${QuestionGroupsTable.lessonId} = l.${LessonTable.id}
          WHERE l.${LessonTable.subjectId} = $subjectId
        )
      )
      AND tq.${TagQuestionTable.idTag} IN (
        SELECT t.${TagTable.id}
        FROM ${TagTable.tableName} t
        WHERE t.${TagTable.idSubject} = $subjectId
      )
    ''');

    // Create a set of existing question-tag pairs
    final existingPairs = existingQuestionTags.map((qt) => '${qt[TagQuestionTable.idQuestion]}_${qt[TagQuestionTable.idTag]}').toSet();

    // Create a set of response question-tag pairs
    final responsePairs = questionTags.where((qt) => subjectQuestionIds.contains(qt.questionId) && subjectTagIds.contains(qt.tagId)).map((qt) => '${qt.questionId}_${qt.tagId}').toSet();

    // Insert new question-tag relations
    for (final qt in questionTags) {
      // Skip if either question or tag doesn't belong to this subject
      if (!subjectQuestionIds.contains(qt.questionId) || !subjectTagIds.contains(qt.tagId)) continue;

      final pairKey = '${qt.questionId}_${qt.tagId}';

      if (!existingPairs.contains(pairKey)) {
        // Insert new question-tag relation
        await txn.insert(TagQuestionTable.tableName, {
          TagQuestionTable.idQuestion: qt.questionId,
          TagQuestionTable.idTag: qt.tagId,
        });
      }
    }

    // Delete question-tag relations that are in the local database but not in the response
    final pairsToDelete = existingPairs.difference(responsePairs);
    for (final pair in pairsToDelete) {
      final parts = pair.split('_');
      final questionId = int.parse(parts[0]);
      final tagId = int.parse(parts[1]);

      await txn.delete(
        TagQuestionTable.tableName,
        where: '${TagQuestionTable.idQuestion} = ? AND ${TagQuestionTable.idTag} = ?',
        whereArgs: [questionId, tagId],
      );
    }
  }

  /// Syncs question types with the local database
  // Future<void> _syncQuestionTypes(List<TypeModel> types, dynamic txn) async {
  //   // Get existing types
  //   final existingTypes = await txn.query(TypeQuestionTable.tableName);

  //   final existingTypeIds = existingTypes.map<int>((type) => type[TypeQuestionTable.id] as int).toSet();
  //   final responseTypeIds = types.map((type) => type.id).toSet();

  //   // Insert or update types
  //   for (final type in types) {
  //     final typeMap = {
  //       TypeQuestionTable.id: type.id,
  //       TypeQuestionTable.name: type.name,
  //     };

  //     if (existingTypeIds.contains(type.id)) {
  //       // Update existing type
  //       await txn.update(
  //         TypeQuestionTable.tableName,
  //         typeMap,
  //         where: '${TypeQuestionTable.id} = ?',
  //         whereArgs: [type.id],
  //       );
  //     } else {
  //       // Insert new type
  //       await txn.insert(TypeQuestionTable.tableName, typeMap);
  //     }
  //   }

  //   // We don't delete types here because they might be used by other subjects
  // }
}
