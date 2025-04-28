// lib/features/subject/domain/usecases/get_tags_or_exams.dart
import 'package:dartz/dartz.dart';
import 'package:sanad_school/features/tags/domain/repo/tag_repository.dart';

import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/tag_entity.dart';

class GetTagsOrExamsUseCase {
  final TagRepository repository;

  GetTagsOrExamsUseCase({required this.repository});

  Future<Either<Failure, List<TagEntity>>> call(TagParams params) async {
    return await repository.getTagsOrExams(params);
  }
}
