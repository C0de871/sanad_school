import 'package:sanad_school/core/databases/cache/secure_storage_helper.dart';

class AuthLocalDataSource {
  final SecureStorageHelper secureStorage;

  static final tokenKey = 'token';

  AuthLocalDataSource({required this.secureStorage});

  Future<void> saveToken(String token) async {
    await secureStorage.saveData(key: tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await secureStorage.getData(key: tokenKey);
  }

  Future<void> deleteToken() async {
    await secureStorage.removeData(key: tokenKey);
  }
}
