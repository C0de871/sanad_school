import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../entities/subject_sync_entity.dart';
import '../repo/subject_repository.dart';

class GetSubjectSyncUseCase {
  final SubjectRepository repository;

  GetSubjectSyncUseCase({required this.repository});

  Future<Either<Failure, SubjectSyncEntity>> call(int subjectId) async {
    return await repository.downloadSubject(subjectId);
  }
}
