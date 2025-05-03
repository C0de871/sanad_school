import 'package:sanad_school/core/databases/api/api_consumer.dart';
import 'package:sanad_school/core/databases/api/end_points.dart';

import '../models/profile_response_model.dart';

class ProfileRemoteDataSource {
  final ApiConsumer api;

  ProfileRemoteDataSource({required this.api});

  Future<ProfileResponseModel> getStudentProfile() async {
    final response = await api.get(EndPoints.studentProfile);
    return ProfileResponseModel.fromMap(response);
  }
}
