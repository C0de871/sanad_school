import 'package:dartz/dartz.dart';

import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/question_entity.dart';

abstract class QuestionRepository {
  Future<Either<Failure, List<QuestionEntity>>> getLessonQuestionsByType({
    required QuestionsInLessonWithTypeParams params,
  });

  Future<Either<Failure, List<QuestionEntity>>> getSubjectQuestionsByTag({
    required QuestionsInSubjectByTag params,
  });
}
