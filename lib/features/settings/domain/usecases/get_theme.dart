// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:sanad_school/features/settings/data/repository/theme_repository.dart';

import '../../../../core/databases/errors/failure.dart';

class GetThemeUsecase {
  ThemeRepository repository;
  GetThemeUsecase({
    required this.repository,
  });

  Future<Either<Failure, ThemeMode>> call() {
    return repository.getTheme();
  }
}
