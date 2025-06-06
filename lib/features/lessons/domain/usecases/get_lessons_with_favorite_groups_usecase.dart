import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/lesson_entity.dart';
import '../entities/lessons_response_entity.dart';
import '../repo/lessons_repository.dart';

class GetLessonsWithFavoriteGroupsUseCase {
  final LessonsRepository repository;

  GetLessonsWithFavoriteGroupsUseCase({required this.repository});

  Future<Either<Failure, LessonsResponseEntity>> call(LessonsWithFavoriteGroupsParams params) async {
    return await repository.getLessonsWithFavoriteGroups(params: params);
  }
}
