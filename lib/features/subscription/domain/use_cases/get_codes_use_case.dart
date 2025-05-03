import 'package:dartz/dartz.dart';

import '../../../../core/databases/errors/failure.dart';
import '../entities/code_data_entity.dart';
import '../repository/code_repository.dart';

class GetCodesUseCase {
  final CodeRepository repository;

  GetCodesUseCase({required this.repository});

  Future<Either<Failure, CodeDataEntity>> call() async {
    return await repository.getCodes();
  }
}
