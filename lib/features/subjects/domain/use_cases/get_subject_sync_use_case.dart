import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../repo/subject_repository.dart';

class GetSubjectSyncUseCase {
  final SubjectRepository repository;

  GetSubjectSyncUseCase({required this.repository});

  Future<Either<Failure, bool>> call(int subjectId, {bool isRefresh = false}) async {
    return await repository.downloadSubject(subjectId, isRefresh: isRefresh);
  }
}
