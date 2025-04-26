import 'package:dartz/dartz.dart';

import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../../../../core/shared/domain/use_cases/use_case.dart';
import '../entities/template_t_entity.dart';
import '../repository/auth_repository.dart';

class LoginUseCase extends UseCase<TemplateTParams, dynamic, TemplateTEntity> {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  @override
  Future<Either<Failure, TemplateTEntity>> call({required TemplateTParams params, required dynamic body}) {
    return repository.login(params: params);
  }
}
