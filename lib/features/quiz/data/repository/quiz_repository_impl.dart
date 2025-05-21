import 'package:sanad_school/features/questions/domain/entities/question_entity.dart';

import '../../../../core/databases/params/params.dart';
import '../../../lessons/domain/entities/lesson_entity.dart';
import '../../../lessons/data/models/question_type_model.dart';
import '../../../tags/domain/entities/tag_entity.dart';
import '../../domain/repository/quiz_repository.dart';

class QuizRepositoryImpl extends QuizRepository {
  QuizRepositoryImpl({required super.filterService});

  @override
  Future<List<QuestionEntity>> getFilteredQuestions({
    required QuizFilterParams params,
  }) async {
    final response = await filterService.getFilteredQuestions(params: params);
    return response.questions;
  }

  @override
  Future<List<LessonEntity>> getAvailableLessons({
    required GetAvailableLessonsParams params,
  }) async {
    final response = await filterService.getAvailableLessons(params: params);
    return response.lessons;
  }

  @override
  Future<List<TagEntity>> getAvailableTags({
    required GetAvailableTagsParams params,
  }) async {
    final response = await filterService.getAvailableTags(params: params);
    return response.tags;
  }

  @override
  Future<List<QuestionTypeModel>> getAvailableTypes({
    required GetAvailableTypesParams params,
  }) async {
    final response = await filterService.getAvailableTypes(params: params);
    return response;
  }

  @override
  Future<int> getFilteredQuestionsCounts({
    required QuizFilterParams params,
  }) async {
    return filterService.getFilteredQuestionsCounts(params: params);
  }
}
