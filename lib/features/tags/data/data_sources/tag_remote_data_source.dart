// lib/features/subject/data/data sources/subject_remote_data_source.dart

import '../../../../core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/databases/params/params.dart';
import '../models/tag_response_model.dart';

class TagRemoteDataSource {
  final ApiConsumer api;

  TagRemoteDataSource({required this.api});

  Future<TagResponseModel> getTagsOrExams(TagParams params) async {
    final endpoint = EndPoints.getTagsOrExamsEndpoint(
      params.subjectId,
      params.isExam,
    );

    final response = await api.get(endpoint);
    return TagResponseModel.fromMap(response);
  }
}
