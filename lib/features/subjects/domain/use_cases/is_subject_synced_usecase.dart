import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../repo/subject_repository.dart';

class IsSubjectSyncedUseCase {
  final SubjectRepository repository;

  IsSubjectSyncedUseCase(this.repository);

  Future<Either<Failure, bool>> call(CheckSubjectSyncParams params) async {
    return await repository.isSubjectSynced(params);
  }
}
