import 'package:sanad_school/features/auth/domain/repository/auth_repository.dart';

class DeleteTokenUseCase {
  final AuthRepository repository;

  DeleteTokenUseCase({required this.repository});

  Future<void> call() async {
    return await repository.deleteToken();
  }
}
