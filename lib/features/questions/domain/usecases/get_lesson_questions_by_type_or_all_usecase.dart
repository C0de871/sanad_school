import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/question_entity.dart';
import '../repo/question_repository.dart';

class GetLessonQuestionsByTypeOrAllUseCase {
  final QuestionRepository repository;

  GetLessonQuestionsByTypeOrAllUseCase(this.repository);

  Future<Either<Failure, List<QuestionEntity>>> call(QuestionsInLessonWithTypeParams params) async {
    return await repository.getLessonQuestionsByTypeOrAll(params: params);
  }
}
