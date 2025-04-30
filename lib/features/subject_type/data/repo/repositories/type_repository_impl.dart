import 'package:dartz/dartz.dart';

import '../../../../../core/databases/connection/network_info.dart';
import '../../../../../core/databases/errors/expentions.dart';
import '../../../../../core/databases/errors/failure.dart';
import '../../../domain/entities/type_entity.dart';
import '../../../domain/repo/type_repository.dart';
import '../../data_sources/type_remote_data_source.dart';

class TypeRepositoryImpl implements TypeRepository {
  final TypeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TypeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TypeEntity>>> getTypes() async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await remoteDataSource.getTypes();
        return Right(response.types);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "There is no internet connection"));
    }
  }
}
