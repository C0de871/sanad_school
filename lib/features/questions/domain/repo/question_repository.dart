import 'package:dartz/dartz.dart';

import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/question_entity.dart';

abstract class QuestionRepository {
  Future<Either<Failure, List<QuestionEntity>>> getLessonQuestionsByTypeOrAll({
    required QuestionsInLessonWithTypeParams params,
  });

  Future<Either<Failure, List<QuestionEntity>>> getSubjectQuestionsByTagOrExam({
    required QuestionsInSubjectByTag params,
  });
}
