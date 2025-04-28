import 'package:dartz/dartz.dart';

import '../../../../core/databases/errors/failure.dart';
import '../entities/subject_entity.dart';
import '../repo/subject_repository.dart';

class GetSubjectsUseCase {
  final SubjectRepository repository;

  GetSubjectsUseCase({required this.repository});

  Future<Either<Failure, List<SubjectEntity>>> call() async {
    return await repository.getSubjects();
  }
}
