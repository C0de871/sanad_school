import 'package:dartz/dartz.dart';
import 'package:sanad_school/core/databases/connection/network_info.dart';
import 'package:sanad_school/core/databases/errors/expentions.dart';
import 'package:sanad_school/core/databases/errors/failure.dart';
import 'package:sanad_school/features/auth/data/data sources/auth_remote_data_source.dart';
import 'package:sanad_school/features/auth/domain/entities/student_entity.dart';
import 'package:sanad_school/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/databases/params/body.dart';
import '../data sources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, StudentEntity>> register(RegisterBody params) async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await remoteDataSource.register(params);
        await localDataSource.saveToken(response.accessToken);
        return Right(response.student);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "There is no internet connection"));
    }
  }

  @override
  Future<Either<Failure, StudentEntity>> login(LoginBody params) async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await remoteDataSource.login(params);
        await localDataSource.saveToken(response.accessToken);
        return Right(response.student);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "There is no internet connection"));
    }
  }

  @override
  Future<String?> getToken() async {
    return await localDataSource.getToken();
  }

  @override
  Future<void> saveToken(String token) async {
    await localDataSource.saveToken(token);
  }

  @override
  Future<void> deleteToken() async {
    await localDataSource.deleteToken();
  }
}
