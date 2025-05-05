import 'dart:developer';

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
}
