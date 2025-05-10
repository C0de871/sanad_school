import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/question_entity.dart';
import '../repo/question_repository.dart';

class GetEditedQuestionsByLessonUseCase {
  final QuestionRepository repository;

  GetEditedQuestionsByLessonUseCase(this.repository);

  Future<Either<Failure, List<QuestionEntity>>> call(EditedQuestionsByLessonParams params) async {
    return await repository.getEditedQuestionsByLesson(params: params);
  }
}
