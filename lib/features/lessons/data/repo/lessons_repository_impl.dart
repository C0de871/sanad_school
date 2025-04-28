// lib/features/lessons/data/repositories/lessons_repository_impl.dart
import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../../core/databases/connection/network_info.dart';
import '../../../../core/databases/errors/expentions.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../../domain/repo/lessons_repository.dart';
import '../data_sources/lessons_remote_data_source.dart';
import '../models/lesson_model.dart';

class LessonsRepositoryImpl extends LessonsRepository {
  final NetworkInfo networkInfo;
  final LessonsRemoteDataSource remoteDataSource;

  LessonsRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<LessonModel>>> getLessons(LessonsParams params) async {
    if (await networkInfo.isConnected!) {
      try {
        log("the api call in repo");
        final response = await remoteDataSource.getLessons(params);
        log("the api call in repo after call");
        return Right(response.lessons);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "There is no internet connection"));
    }
  }
}
