import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/question_entity.dart';
import '../repo/question_repository.dart';

class GetIncorrectAnswerGroupsQuestionsUseCase {
  final QuestionRepository repository;

  GetIncorrectAnswerGroupsQuestionsUseCase(this.repository);

  Future<Either<Failure, List<QuestionEntity>>> call(IncorrectAnswerGroupsQuestionsParams params) async {
    return await repository.getIncorrectAnswerGroupsQuestions(params: params);
  }
}
