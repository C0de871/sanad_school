// lib/features/subject/data/repositories/subject_repository_impl.dart
import 'package:dartz/dartz.dart';

import '../../../../core/databases/connection/network_info.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../../domain/entities/tag_entity.dart';
import '../../domain/repo/tag_repository.dart';
import '../data_sources/tag_local_data_source.dart';
import '../data_sources/tag_remote_data_source.dart';

class TagRepositoryImpl implements TagRepository {
  final TagRemoteDataSource remoteDataSource;
  final TagLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TagRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TagEntity>>> getTagsOrExams(TagParams params) async {
    final response = await localDataSource.getAllTagsBySubject(params.subjectId, params.isExam ? 1 : 0);
    return Right(response.tags);
  }
}
