// lib/features/subject/data/repositories/subject_repository_impl.dart
import 'package:dartz/dartz.dart';

import '../../../../core/databases/connection/network_info.dart';
import '../../../../core/databases/errors/expentions.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../../domain/entities/tag_entity.dart';
import '../../domain/repo/tag_repository.dart';
import '../data_sources/tag_remote_data_source.dart';

class TagRepositoryImpl implements TagRepository {
  final TagRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TagRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TagEntity>>> getTagsOrExams(TagParams params) async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await remoteDataSource.getTagsOrExams(params);
        return Right(response.tags);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "There is no internet connection"));
    }
  }
}
