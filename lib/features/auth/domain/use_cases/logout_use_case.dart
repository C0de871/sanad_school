import 'package:dartz/dartz.dart';
import 'package:sanad_school/core/databases/errors/failure.dart';
import 'package:sanad_school/features/auth/domain/repository/auth_repository.dart';
import 'package:sanad_school/features/auth/data/model/logout_response_model.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase({required this.repository});

  Future<Either<Failure, LogoutResponseModel>> call() async {
    return await repository.logout();
  }
}
