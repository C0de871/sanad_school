import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/question_entity.dart';
import '../repo/question_repository.dart';

class GetQuestionsInLessonByTypeUseCase {
  final QuestionRepository repository;

  GetQuestionsInLessonByTypeUseCase({required this.repository});

  Future<Either<Failure, List<QuestionEntity>>> call({
    required QuestionsInLessonWithTypeParams params,
  }) async {
    return await repository.getLessonQuestionsByTypeOrAll(params: params);
  }
}
