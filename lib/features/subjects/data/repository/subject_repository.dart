import 'package:dartz/dartz.dart';

import '../../../../core/databases/connection/network_info.dart';
import '../../../../core/databases/errors/expentions.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../domain/entities/subject_entity.dart';
import '../../domain/repo/subject_repository.dart';
import '../data_sources/subject_remote_data_source.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  final SubjectRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SubjectRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SubjectEntity>>> getSubjects() async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await remoteDataSource.getSubjects();
        return Right(response.subjects);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "There is no internet connection."));
    }
  }
}
