import 'dart:typed_data';

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

  Future<Either<Failure, List<QuestionEntity>>> getFavoriteGroupsQuestions({
    required FavoriteGroupsQuestionsParams params,
  });

  Future<Either<Failure, List<QuestionEntity>>> getIncorrectAnswerGroupsQuestions({
    required IncorrectAnswerGroupsQuestionsParams params,
  });

  Future<Either<Failure, List<QuestionEntity>>> getEditedQuestionsByLesson({
    required EditedQuestionsByLessonParams params,
  });

  Future<Either<Failure, bool>> toggleQuestionFavorite({
    required ToggleQuestionFavoriteParams params,
  });

  Future<Either<Failure, bool>> toggleQuestionIncorrectAnswer({
    required ToggleQuestionIncorrectAnswerParams params,
  });

  Future<Either<Failure, bool>> saveQuestionNote({
    required SaveQuestionNoteParams params,
  });

  Future<Either<Failure, String?>> getQuestionNote({
    required GetQuestionNoteParams params,
  });

  // Future<Either<Failure, bool>> saveQuestionPhoto({
  //   required QuestionPhotoParams params,
  // });

  Future<Either<Failure, Uint8List?>> getQuestionPhoto({
    required QuestionPhotoParams params,
  });

  Future<Either<Failure, bool>> saveQuestionHintPhoto({
    required QuestionPhotoParams params,
  });

  Future<Either<Failure, Uint8List?>> getQuestionHintPhoto({
    required QuestionPhotoParams params,
  });

  //updates methods:
  Future<Either<Failure, bool>> updateQuestionAnswered({
    required UpdateQuestionAnsweredParams params,
  });

  Future<Either<Failure, bool>> updateQuestionCorrected({
    required UpdateQuestionCorrectedParams params,
  });

  Future<Either<Failure, bool>> updateQuestionAnsweredCorrectly({
    required UpdateQuestionAnsweredCorrectlyParams params,
  });
}
