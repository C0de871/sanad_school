import 'package:dartz/dartz.dart';
import 'package:sanad_school/core/databases/errors/failure.dart';

import '../../../databases/params/params.dart';

abstract class UseCase<Parameter extends Params, Body, Result> {
  Future<Either<Failure, Result>> call({required Parameter params, required Body body});
}
