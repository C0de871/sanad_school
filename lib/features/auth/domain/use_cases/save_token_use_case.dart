import 'package:sanad_school/features/auth/domain/repository/auth_repository.dart';

class SaveTokenUseCase {
  final AuthRepository repository;

  SaveTokenUseCase({required this.repository});

  Future<void> call(String token) async {
    await repository.saveToken(token);
    return;
  }
}
