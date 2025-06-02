import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/lesson_entity.dart';
import '../entities/lessons_response_entity.dart';
import '../repo/lessons_repository.dart';

class GetLessonsWithEditedQuestionsUseCase {
  final LessonsRepository repository;

  GetLessonsWithEditedQuestionsUseCase({required this.repository});

  Future<Either<Failure, LessonsResponseEntity>> call(LessonsWithEditedQuestionsParams params) async {
    return await repository.getLessonsWithEditedQuestions(params: params);
  }
}
