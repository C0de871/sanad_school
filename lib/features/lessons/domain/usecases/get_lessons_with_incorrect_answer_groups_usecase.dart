import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/lesson_entity.dart';
import '../repo/lessons_repository.dart';

class GetLessonsWithIncorrectAnswerGroupsUseCase {
  final LessonsRepository repository;

  GetLessonsWithIncorrectAnswerGroupsUseCase({required this.repository});

  Future<Either<Failure, List<LessonEntity>>> call(LessonsWithIncorrectAnswerGroupsParams params) async {
    return await repository.getLessonsWithIncorrectAnswerGroups(params: params);
  }
}
