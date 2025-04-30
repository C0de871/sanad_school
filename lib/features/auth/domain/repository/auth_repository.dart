import 'package:dartz/dartz.dart';
import 'package:sanad_school/core/databases/errors/failure.dart';
import 'package:sanad_school/features/auth/domain/entities/student_entity.dart';

import '../../../../core/databases/params/body.dart';

abstract class AuthRepository {
  Future<Either<Failure, StudentEntity>> register(RegisterBody params);
  Future<Either<Failure, StudentEntity>> login(LoginBody params);

  //! Token management methods
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> deleteToken();
}
