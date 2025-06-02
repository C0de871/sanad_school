import 'package:dartz/dartz.dart';

import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../repo/question_repository.dart';

//to update the question answered correctly status and it depend on the user answer
class UpdateQuestionAnsweredCorrectlyUsecase {
  final QuestionRepository repository;

  UpdateQuestionAnsweredCorrectlyUsecase({required this.repository});

  Future<Either<Failure, bool>> call(
      UpdateQuestionAnsweredCorrectlyParams params) async {
    return repository.updateQuestionAnsweredCorrectly(params: params);
  }
}
