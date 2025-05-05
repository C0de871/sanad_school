import 'dart:developer';
import 'package:dartz/dartz.dart';

import '../../../../core/databases/connection/network_info.dart';
import '../../../../core/databases/errors/expentions.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../domain/entities/subject_entity.dart';
import '../../domain/entities/subject_sync_entity.dart';
import '../../domain/repo/subject_repository.dart';
import '../data_sources/subject_details_data_source.dart';
import '../data_sources/subject_remote_data_source.dart';
import '../data_sources/subject_local_data_source.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final SubjectRemoteDataSource remoteDataSource;
  final SubjectLocalDataSource localDataSource;
  final SubjectDetailLocalDataSource subjectDetailLocalDataSource;
  final NetworkInfo networkInfo;

  SubjectRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.subjectDetailLocalDataSource,
  });

  @override
  Future<Either<Failure, List<SubjectEntity>>> getSubjects() async {
    final subjectsFromLocal = await localDataSource.getAllSubjects();
    // log("subjectsFromLocal: $subjectsFromLocal");
    if (subjectsFromLocal.isEmpty) {
      if (await networkInfo.isConnected!) {
        try {
          final response = await remoteDataSource.getSubjects();
          // log("response: $response");
          await localDataSource.syncSubjectsAndTypes(response);
          return Right(response.data.subjects); //!data
        } on ServerException catch (e) {
        log("error: ${e.toString()}");
          return Left(Failure(errMessage: e.errorModel.errorMessage));
        }
      } else {
        return Left(Failure(errMessage: "There is no internet connection."));
      }
    } else {
      return Right(subjectsFromLocal);
    }
  }

  @override
  Future<Either<Failure, SubjectSyncEntity>> downloadSubject(int subjectId) async {

    if (await networkInfo.isConnected!) {
      try {
        // 1. Fetch the subject data from the remote source
        final remoteSubject = await remoteDataSource.getSubjectSync(subjectId);

        // 2. sync subject details with local database
        await subjectDetailLocalDataSource.syncSubjectDetails(remoteSubject);

        return Right(remoteSubject);
      } on ServerException catch (e) {
        log("server exception");
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: 'No internet connection'));
    }
  }
}
