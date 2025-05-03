// lib/features/student/domain/usecases/get_student_profile.dart
import 'package:dartz/dartz.dart';
import 'package:sanad_school/core/databases/errors/failure.dart';
import 'package:sanad_school/features/profile/domain/entities/profile_entity.dart';

import '../repo/profile_repo.dart';

class GetStudentProfileUseCase {
  final ProfileRepository repository;

  GetStudentProfileUseCase({required this.repository});

  Future<Either<Failure, ProfileEntity>> call() async {
    return await repository.getStudentProfile();
  }
}
