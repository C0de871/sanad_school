import 'package:dartz/dartz.dart';
import 'package:sanad_school/features/auth/data/data%20sources/auth_remote_data_source.dart';

import '../../../../core/databases/connection/network_info.dart';
import '../../../../core/databases/errors/expentions.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../../domain/entities/template_t_entity.dart';
import '../../domain/repository/auth_repository.dart';

class TemplateTRepositoryImple extends AuthRepository {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource remoteDataSource;
  TemplateTRepositoryImple({required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, TemplateTEntity>> login({required TemplateTParams params}) async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteTempleT = await remoteDataSource.login(params);

        return Right(remoteTempleT);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      //TODO make this message adapt to app language:
      return Left(Failure(errMessage: "There is no internet connnect"));
    }
  }
}
