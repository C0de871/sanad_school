// lib/features/student/domain/repositories/student_repository.dart
import 'package:dartz/dartz.dart';
import 'package:sanad_school/core/databases/errors/failure.dart';

import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getStudentProfile();
}
