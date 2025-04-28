import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../entities/subject_entity.dart';

abstract class SubjectRepository {
  Future<Either<Failure, List<SubjectEntity>>> getSubjects();
}
