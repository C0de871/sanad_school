import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../../core/databases/connection/network_info.dart';
import '../../../../core/databases/errors/expentions.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../../domain/entities/code_data_entity.dart';
import '../../domain/entities/code_entity.dart';
import '../../domain/repository/code_repository.dart';
import '../data_sources/code_remote_data_source.dart';

class CodeRepositoryImpl implements CodeRepository {
  final CodeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CodeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CodeDataEntity>> getCodes() async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await remoteDataSource.getCodes();
        return Right(response.data);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "There is no internet connection"));
    }
  }

  @override
  Future<Either<Failure, CodeEntity>> checkCode(CodeBody params) async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await remoteDataSource.checkCode(params);
        return Right(response.code);
      } on ServerException catch (e) {
        log("from check code ${e.errorModel.errorMessage}");
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      } catch (e) {
        log(e.toString());
        return Left(Failure(errMessage: e.toString()));
      }
    } else {
      return Left(Failure(errMessage: "There is no internet connection"));
    }
  }
}
