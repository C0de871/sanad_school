import '../../../../core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../models/subject_response_model.dart';
import '../models/subject_sync_model.dart';

class SubjectRemoteDataSource {
  final ApiConsumer api;

  SubjectRemoteDataSource({required this.api});

  Future<SubjectResponseModel> getSubjects() async {
    final response = await api.get(EndPoints.subject);
    return SubjectResponseModel.fromMap(response);
  }

  Future<SubjectSyncModel> getSubjectSync(int subjectId) async {
    final response = await api.get(EndPoints.subjectSyncEndpoint(subjectId));
    return SubjectSyncModel.fromMap(response);
  }
}
