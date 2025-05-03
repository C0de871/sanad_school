// lib/features/lessons/data/repositories/lessons_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/databases/connection/network_info.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../../domain/repo/lessons_repository.dart';
import '../data_sources/lessons_local_data_source.dart';
import '../data_sources/lessons_remote_data_source.dart';
import '../models/lesson_model.dart';

class LessonsRepositoryImpl extends LessonsRepository {
  final NetworkInfo networkInfo;
  final LessonsRemoteDataSource remoteDataSource;
  final LessonsLocalDataSource localDataSource;

  LessonsRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<LessonModel>>> getLessons(LessonsParams params) async {
    try {
      final response = await localDataSource.getLessonsWithQuestionTypes(params.subjectId);
      return Right(response.lessons);
    } catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }
}
