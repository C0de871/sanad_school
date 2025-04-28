import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/question_entity.dart';
import '../repo/question_repository.dart';

class GetQuestionsInSubjectByTagUseCase {
  final QuestionRepository repository;

  GetQuestionsInSubjectByTagUseCase({required this.repository});

  Future<Either<Failure, List<QuestionEntity>>> call({
    required QuestionsInSubjectByTag params,
  }) async {
    return await repository.getSubjectQuestionsByTag(params: params);
  }
}
