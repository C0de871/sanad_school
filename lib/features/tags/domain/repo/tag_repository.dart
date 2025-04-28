// lib/features/subject/domain/repositories/subject_repository.dart
import 'package:dartz/dartz.dart';

import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/tag_entity.dart';

abstract class TagRepository {
  Future<Either<Failure, List<TagEntity>>> getTagsOrExams(TagParams params);
}