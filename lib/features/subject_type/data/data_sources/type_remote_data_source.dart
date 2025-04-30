import '../../../../core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../models/type_response_model.dart';

class TypeRemoteDataSource {
  final ApiConsumer api;

  TypeRemoteDataSource({required this.api});

  Future<TypeResponseModel> getTypes() async {
    final response = await api.get("${EndPoints.baseUrl}${EndPoints.types}");
    return TypeResponseModel.fromMap(response);
  }
}
