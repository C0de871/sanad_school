
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:sanad_school/features/questions/data/data_sources/question_local_data_source.dart';
import '../../../../core/databases/connection/network_info.dart';
import '../../../../core/databases/errors/expentions.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/repo/question_repository.dart';
import '../data_sources/question_remote_data_source.dart';

class QuestionRepositoryImpl extends QuestionRepository {
  final NetworkInfo networkInfo;
  final QuestionRemoteDataSource remoteDataSource;
  final QuestionLocalDataSource localDataSource;

  QuestionRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<QuestionEntity>>> getLessonQuestionsByTypeOrAll({
    required QuestionsInLessonWithTypeParams params,
  }) async {
    try {
      // final response = await remoteDataSource.getQuestionsInLessonByType(
      //   params: params,
      // );

      final response = await localDataSource.getQuestionsByLessonAndType(params.lessonId, params.typeId);
      // log("response: ${response.questions.toString()}");
      return Right(response.questions);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<QuestionEntity>>> getSubjectQuestionsByTagOrExam({
    required QuestionsInSubjectByTag params,
  }) async {
    try {
      final response = await localDataSource.getQuestionsByTag(params.tagId);
      return Right(response.questions);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<QuestionEntity>>> getEditedQuestionsByLesson({required EditedQuestionsByLessonParams params}) async {
    try {
      final response = await localDataSource.getEditedQuestionsByLesson(params.lessonId, params.typeId);
      return Right(response.questions);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<QuestionEntity>>> getFavoriteGroupsQuestions({required FavoriteGroupsQuestionsParams params}) async {
    try {
      final response = await localDataSource.getFavoriteGroupsQuestions(params.lessonId, params.typeId);
      return Right(response.questions);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<QuestionEntity>>> getIncorrectAnswerGroupsQuestions({required IncorrectAnswerGroupsQuestionsParams params}) async {
    try {
      final response = await localDataSource.getIncorrectAnswerGroupsQuestions(params.lessonId, params.typeId);
      return Right(response.questions);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, String?>> getQuestionNote({required GetQuestionNoteParams params}) async {
    try {
      final response = await localDataSource.getQuestionNote(params.questionId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> saveQuestionNote({required SaveQuestionNoteParams params}) async {
    try {
      final response = await localDataSource.saveQuestionNote(params.questionId, params.note);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleQuestionFavorite({required ToggleQuestionFavoriteParams params}) async {
    try {
      final response = await localDataSource.toggleQuestionFavorite(params.questionId, params.isFavorite);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleQuestionIncorrectAnswer({required ToggleQuestionIncorrectAnswerParams params}) async {
    try {
      final response = await localDataSource.toggleQuestionIncorrectAnswer(params.questionId, params.answerStatus);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> saveQuestionPhoto({required QuestionPhotoParams params}) async {
    try {
      final photo = await remoteDataSource.downloadQuestionPhoto(params: params);
      final response = await localDataSource.saveQuestionPhoto(params.questionId, photo);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Uint8List?>> getQuestionPhoto({required QuestionPhotoParams params}) async {
    try {
      final photo = await localDataSource.getQuestionPhoto(params.questionId);
      if (photo != null) {
        return Right(photo);
      } else {
        if (await networkInfo.isConnected!) {
          final photo = await remoteDataSource.downloadQuestionPhoto(params: params);
          await localDataSource.saveQuestionPhoto(params.questionId, photo);
          return Right(photo);
        } else {
          return Left(Failure(errMessage: 'No internet connection'));
        }
      }
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> saveQuestionHintPhoto({required QuestionPhotoParams params}) async {
    try {
      final photo = await remoteDataSource.downloadQuestionPhoto(params: params);
      final response = await localDataSource.saveQuestionHintPhoto(params.questionId, photo);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Uint8List?>> getQuestionHintPhoto({required QuestionPhotoParams params}) async {
    try {
      final photo = await localDataSource.getQuestionHintPhoto(params.questionId);
      if (photo != null) {
        return Right(photo);
      } else {
        if (await networkInfo.isConnected!) {
          final photo = await remoteDataSource.downloadQuestionPhoto(params: params);
           await localDataSource.saveQuestionHintPhoto(params.questionId, photo);
          return Right(photo);
        } else {
          return Left(Failure(errMessage: 'No internet connection'));
        }
      }
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }
  
  @override
  Future<Either<Failure, bool>> updateQuestionAnswered({required UpdateQuestionAnsweredParams params})async {
    try {
      final response = await localDataSource.updateQuestionAnswered(params.questionId, params.isAnswered, params.userAnswer);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }
  
  @override
  Future<Either<Failure, bool>> updateQuestionAnsweredCorrectly({required UpdateQuestionAnsweredCorrectlyParams params})async {
    try {
      final response = await localDataSource.updateQuestionAnsweredCorrectly(params.questionId, params.isAnsweredCorrectly);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }
  
  @override
  Future<Either<Failure, bool>> updateQuestionCorrected({required UpdateQuestionCorrectedParams params})async {
    try {
      final response = await localDataSource.updateQuestionCorrected(params.questionId, params.isCorrected);
      return Right(response);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }
  }
}
