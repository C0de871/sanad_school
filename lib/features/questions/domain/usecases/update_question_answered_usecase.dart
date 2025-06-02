import 'package:dartz/dartz.dart';

import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../repo/question_repository.dart';

//change the isAnswered status and which answer is selected and it not effected if the user answer is wrong or right
class UpdateQuestionAnsweredUsecase {
  final QuestionRepository repository;

  UpdateQuestionAnsweredUsecase({required this.repository});

  Future<Either<Failure, bool>> call(
      UpdateQuestionAnsweredParams params) async {
    return repository.updateQuestionAnswered(params: params);
  }
}
