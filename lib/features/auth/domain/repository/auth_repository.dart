import 'package:dartz/dartz.dart';

import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/template_t_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, TemplateTEntity>> login({required TemplateTParams params});
}
