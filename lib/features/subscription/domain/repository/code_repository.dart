import 'package:dartz/dartz.dart';

import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/code_data_entity.dart';
import '../entities/code_entity.dart';

abstract class CodeRepository {
  Future<Either<Failure, CodeDataEntity>> getCodes();
  Future<Either<Failure, CodeEntity>> checkCode(CodeBody params);
}
