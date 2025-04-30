import 'package:dartz/dartz.dart';

import '../../../../core/databases/errors/failure.dart';
import '../entities/type_entity.dart';
import '../repo/type_repository.dart';

class GetTypesUseCase {
  final TypeRepository repository;

  GetTypesUseCase({required this.repository});

  Future<Either<Failure, List<TypeEntity>>> call() async {
    return await repository.getTypes();
  }
}
