import 'dart:developer';

import 'package:sanad_school/core/databases/local_database/sql_db.dart';
import 'package:sanad_school/core/databases/local_database/tables/subject_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/type_question_table.dart';
import 'package:sanad_school/features/lessons/data/models/question_type_model.dart';

import '../models/subject_model.dart';
import '../models/subjects_response_model.dart';

class SubjectLocalDataSource {
  final SqlDB _db = SqlDB();

  /// Syncs subjects and question types from the first API response
  /// Updates existing data, inserts new data, and removes data not in the response
  Future<void> syncSubjectsAndTypes(SubjectResponseModel responseModel) async {
    await _syncSubjects(responseModel.data.subjects); //! data
    await _syncQuestionTypes(responseModel.data.questionTypes); //!data
    // await _db.logAllTables();
  }

  /// Checks if a specific subject is synced by checking its sync status column
  Future<bool> isSubjectSynced(int subjectId) async {
    final result = await _db.readData(SubjectTable.tableName, where: '${SubjectTable.id} = $subjectId');

    if (result.isEmpty) return false;

    return result.first[SubjectTable.isSynced] == 1;
  }

  /// Syncs subjects with the local database
  /// Updates existing subjects, inserts new subjects, and removes subjects not in the list
  Future<void> _syncSubjects(List<SubjectModel> subjects) async {
    final existingSubjects = await _db.readData(SubjectTable.tableName);
    final existingSubjectIds = existingSubjects.map<int>((sub) => sub[SubjectTable.id] as int).toSet();
    final responseSubjectIds = subjects.map((sub) => sub.id).toSet();

    // Insert or update subjects
    for (final subject in subjects) {
      final subjectMap = subject.toMap();
      if (existingSubjectIds.contains(subject.id)) {
        // Update existing subject
        await _db.updateData(
          SubjectTable.tableName,
          subjectMap,
          '${SubjectTable.id} = ${subject.id}',
        );
      } else {
        // Insert new subject
        log("inserting new subject: ${subjectMap}");
        await _db.insertData(SubjectTable.tableName, subjectMap);
      }
    }

    // Delete subjects that are in the local database but not in the response
    final subjectsToDelete = existingSubjectIds.difference(responseSubjectIds);
    for (final id in subjectsToDelete) {
      await _db.deleteData(
        SubjectTable.tableName,
        '${SubjectTable.id} = $id',
      );
    }
  }

  /// Syncs question types with the local database
  /// Updates existing types, inserts new types, and removes types not in the list
  Future<void> _syncQuestionTypes(List<QuestionTypeModel> types) async {
    final existingTypes = await _db.readData(TypeQuestionTable.tableName);
    final existingTypeIds = existingTypes.map<int>((type) => type[TypeQuestionTable.id] as int).toSet();
    final responseTypeIds = types.where((type) => type.id != null).map((type) => type.id!).toSet();

    // Insert or update question types
    for (final type in types) {
      if (type.id == null) continue; // Skip types without ID

      final typeMap = {
        TypeQuestionTable.id: type.id,
        TypeQuestionTable.name: type.name,
      };

      if (existingTypeIds.contains(type.id)) {
        // Update existing type
        await _db.updateData(
          TypeQuestionTable.tableName,
          typeMap,
          '${TypeQuestionTable.id} = ${type.id}',
        );
      } else {
        // Insert new type
        await _db.insertData(TypeQuestionTable.tableName, typeMap);
      }
    }

    // Delete types that are in the local database but not in the response
    final typesToDelete = existingTypeIds.difference(responseTypeIds);
    for (final id in typesToDelete) {
      await _db.deleteData(
        TypeQuestionTable.tableName,
        '${TypeQuestionTable.id} = $id',
      );
    }
  }

  // Get all subjects from database

  Future<List<SubjectModel>> getAllSubjects() async {
    final List<Map<String, dynamic>> response = await _db.readData(SubjectTable.tableName);

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
        isLocked: subjectMap[SubjectTable.isLocked],
        teacher: subjectMap[SubjectTable.teacher],
        description: subjectMap[SubjectTable.description],
      );
    }).toList();
  }
}
