// lib/features/lessons/data/data sources/lessons_remote_data_source.dart
import '../../../../core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/databases/params/params.dart';
import '../models/lessons_response_model.dart';

class LessonsRemoteDataSource {
  final ApiConsumer api;

  LessonsRemoteDataSource({required this.api});

  Future<LessonsResponseModel> getLessons(LessonsParams params) async {
    final response = await api.get(
      EndPoints.lessonEndpoint(params.subjectId),
    );
    return LessonsResponseModel.fromMap(response);
  }
}
