import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:sanad_school/core/databases/connection/network_info.dart';
import 'package:sanad_school/core/databases/errors/expentions.dart';
import 'package:sanad_school/core/databases/errors/failure.dart';
import 'package:sanad_school/features/auth/data/data sources/auth_remote_data_source.dart';
import 'package:sanad_school/features/auth/domain/entities/student_entity.dart';
import 'package:sanad_school/features/auth/domain/repository/auth_repository.dart';
import 'package:sanad_school/features/auth/data/model/logout_response_model.dart';
import 'package:sanad_school/features/settings/data/datasources/theme_loca_data_source.dart';
import 'package:sanad_school/features/settings/data/repository/theme_repository.dart';

import '../../../../core/databases/params/body.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final NetworkInfo networkInfo;
  final ThemeLocaDataSource localDataSource;

  ThemeRepositoryImpl({
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> changeTheme({required ThemeMode mode}) async {
    if (await networkInfo.isConnected!) {
      try {
        await localDataSource.changeTheme(mode);
        return Right(null);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "There is no internet connection"));
    }
  }

  @override
  Future<Either<Failure, ThemeMode>> getTheme() async {
    if (await networkInfo.isConnected!) {
      try {
        final themeMode = await localDataSource.getTheme();
        return Right(themeMode);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "There is no internet connection"));
    }
  }
}
