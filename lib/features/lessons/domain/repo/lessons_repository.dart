// lib/features/lessons/domain/repositories/lessons_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/lesson_entity.dart';
import '../entities/lessons_response_entity.dart';

abstract class LessonsRepository {
  Future<Either<Failure, LessonsResponseEntity>> getLessons(
      LessonsParams params);

  Future<Either<Failure, LessonsResponseEntity>> getLessonsWithFavoriteGroups({
    required LessonsWithFavoriteGroupsParams params,
  });

  Future<Either<Failure, LessonsResponseEntity>>
      getLessonsWithIncorrectAnswerGroups({
    required LessonsWithIncorrectAnswerGroupsParams params,
  });

  Future<Either<Failure, LessonsResponseEntity>> getLessonsWithEditedQuestions({
    required LessonsWithEditedQuestionsParams params,
  });
}
