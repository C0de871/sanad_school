import 'package:dartz/dartz.dart';

import '../../../../core/databases/errors/failure.dart';
import '../entities/type_entity.dart';

abstract class TypeRepository {
  Future<Either<Failure, List<TypeEntity>>> getTypes();
}