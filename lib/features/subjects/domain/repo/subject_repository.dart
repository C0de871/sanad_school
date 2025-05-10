import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../entities/subject_entity.dart';

abstract class SubjectRepository {
  Future<Either<Failure, List<SubjectEntity>>> getSubjects({bool isRefresh = false});
  Future<Either<Failure, bool>> downloadSubject(int subjectId, {bool isRefresh = false});
  Future<Either<Failure, bool>> isSubjectSynced(CheckSubjectSyncParams params);
}
