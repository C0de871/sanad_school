import '../../../../core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/databases/params/params.dart';
import '../models/questions_response_model.dart';

class QuestionRemoteDataSource {
  final ApiConsumer api;

  QuestionRemoteDataSource({required this.api});

  Future<QuestionsResponseModel> getQuestionsInLessonByType({
    required QuestionsInLessonWithTypeParams params,
  }) async {
    final response = await api.get(
      EndPoints.questionInLessonWithType(params: params),
    );
    return QuestionsResponseModel.fromMap(response);
  }

  Future<QuestionsResponseModel> getQuestionsInSubjectByTag({
    required QuestionsInSubjectByTag params,
  }) async {
    final response = await api.get(
      EndPoints.questionInSubjectbByTag(params: params),
    );
    return QuestionsResponseModel.fromMap(response);
  }
}
