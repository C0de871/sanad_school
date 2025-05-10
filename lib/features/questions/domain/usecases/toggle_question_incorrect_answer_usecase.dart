import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../repo/question_repository.dart';

class ToggleQuestionIncorrectAnswerUseCase {
  final QuestionRepository repository;

  ToggleQuestionIncorrectAnswerUseCase(this.repository);

  Future<Either<Failure, bool>> call(ToggleQuestionIncorrectAnswerParams params) async {
    return await repository.toggleQuestionIncorrectAnswer(params: params);
  }
}
