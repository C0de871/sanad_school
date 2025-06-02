import 'package:dartz/dartz.dart';

import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../repo/question_repository.dart';

//!to update the question corrected status
class UpdateQuestionCorrectedUsecase {
  final QuestionRepository repository;

  UpdateQuestionCorrectedUsecase({required this.repository});

  Future<Either<Failure, bool>> call(
      UpdateQuestionCorrectedParams params) async {
    return repository.updateQuestionCorrected(params: params);
  }
}
