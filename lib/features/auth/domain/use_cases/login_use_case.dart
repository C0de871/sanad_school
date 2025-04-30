import 'package:dartz/dartz.dart';
import 'package:sanad_school/core/databases/errors/failure.dart';
import 'package:sanad_school/features/auth/domain/entities/student_entity.dart';
import 'package:sanad_school/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/databases/params/body.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<Either<Failure, StudentEntity>> call(LoginBody params) async {
    return await repository.login(params);
  }
}
