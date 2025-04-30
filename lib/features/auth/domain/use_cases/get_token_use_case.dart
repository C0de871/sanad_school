
import 'package:sanad_school/features/auth/domain/repository/auth_repository.dart';

class GetTokenUseCase {
  final AuthRepository repository;

  GetTokenUseCase({required this.repository});

  Future<String?> call() async {
    final token = await repository.getToken();
    return token;
  }
}
