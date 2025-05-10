import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/question_entity.dart';
import '../repo/question_repository.dart';

class GetFavoriteGroupsQuestionsUseCase {
  final QuestionRepository repository;

  GetFavoriteGroupsQuestionsUseCase(this.repository);

  Future<Either<Failure, List<QuestionEntity>>> call(FavoriteGroupsQuestionsParams params) async {
    return await repository.getFavoriteGroupsQuestions(params: params);
  }
}
