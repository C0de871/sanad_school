// lib/features/code_check/domain/use_cases/check_code_use_case.dart
import 'package:dartz/dartz.dart';

import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/code_entity.dart';
import '../repository/code_repository.dart';

class CheckCodeUseCase {
  final CodeRepository repository;

  CheckCodeUseCase({required this.repository});

  Future<Either<Failure, CodeEntity>> call(CodeBody params) async {
    return await repository.checkCode(params);
  }
}
