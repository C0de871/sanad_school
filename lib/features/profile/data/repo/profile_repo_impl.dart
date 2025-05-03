// lib/features/student/data/repositories/student_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:sanad_school/core/databases/connection/network_info.dart';
import 'package:sanad_school/core/databases/errors/failure.dart';

import '../../../../core/databases/errors/expentions.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repo/profile_repo.dart';
import '../data_sources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProfileEntity>> getStudentProfile() async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteStudent = await remoteDataSource.getStudentProfile();
        return Right(remoteStudent.student);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "There is no internet connection"));
    }
  }
}
