import 'package:sanad_school/core/databases/api/api_consumer.dart';
import 'package:sanad_school/core/databases/api/end_points.dart';

import '../../../../core/databases/params/body.dart';
import '../model/register_response_model.dart';

class AuthRemoteDataSource {
  final ApiConsumer api;

  AuthRemoteDataSource({required this.api});

  Future<AuthResponseModel> register(RegisterBody params) async {
    final response = await api.post(
      "${EndPoints.baseUrl}${EndPoints.register}",
      data: params.toMap(),
    );
    return AuthResponseModel.fromMap(response);
  }

  Future<AuthResponseModel> login(LoginBody params) async {
    final response = await api.post(
      EndPoints.login,
      data: params.toMap(),
    );
    return AuthResponseModel.fromMap(response);
  }
}
