import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../repo/question_repository.dart';

class ToggleQuestionFavoriteUseCase {
  final QuestionRepository repository;

  ToggleQuestionFavoriteUseCase(this.repository);

  Future<Either<Failure, bool>> call(ToggleQuestionFavoriteParams params) async {
    return await repository.toggleQuestionFavorite(params: params);
  }
}
