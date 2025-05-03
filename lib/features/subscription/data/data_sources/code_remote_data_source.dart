import '../../../../core/databases/params/params.dart';
import '../models/check_code_response_model.dart';
import '../models/code_response_model.dart';
import '../../../../core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/end_points.dart';

class CodeRemoteDataSource {
  final ApiConsumer api;

  CodeRemoteDataSource({required this.api});

  Future<CodeResponseModel> getCodes() async {
    final response = await api.get('${EndPoints.baseUrl}${EndPoints.code}');
    return CodeResponseModel.fromMap(response);
  }

  Future<CheckCodeResponseModel> checkCode(CodeBody params) async {
    final response = await api.post(
      '${EndPoints.baseUrl}${EndPoints.check}',
      data: params.toMap(),
    );
    return CheckCodeResponseModel.fromMap(response);
  }
}
