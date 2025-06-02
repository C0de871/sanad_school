import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:sanad_school/core/databases/errors/failure.dart';

abstract class ThemeRepository {
  Future<Either<Failure, void>> changeTheme({required ThemeMode mode});
  Future<Either<Failure, ThemeMode>> getTheme();
}
