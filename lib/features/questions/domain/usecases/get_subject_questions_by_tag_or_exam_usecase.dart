import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/question_entity.dart';
import '../repo/question_repository.dart';

class GetSubjectQuestionsByTagOrExamUseCase {
  final QuestionRepository repository;

  GetSubjectQuestionsByTagOrExamUseCase(this.repository);

  Future<Either<Failure, List<QuestionEntity>>> call(QuestionsInSubjectByTag params) async {
    return await repository.getSubjectQuestionsByTagOrExam(params: params);
  }
}
