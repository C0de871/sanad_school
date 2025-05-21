import '../../../../core/databases/params/params.dart';
import '../../../lessons/domain/entities/question_type_entity.dart';
import '../../../questions/domain/entities/question_entity.dart';
import '../../../lessons/domain/entities/lesson_entity.dart';
import '../../../tags/domain/entities/tag_entity.dart';
import '../../data/datasources/quiz_local_data_source.dart';

abstract class QuizRepository {
  final QuizLocalDataSource filterService;

  QuizRepository({required this.filterService});

  Future<List<QuestionEntity>> getFilteredQuestions({
    required QuizFilterParams params,
  });

  Future<List<LessonEntity>> getAvailableLessons({
    required GetAvailableLessonsParams params,
  });

  Future<List<TagEntity>> getAvailableTags({
    required GetAvailableTagsParams params,
  });

  Future<List<QuestionTypeEntity>> getAvailableTypes({
    required GetAvailableTypesParams params,
  });

  Future<int> getFilteredQuestionsCounts({
    required QuizFilterParams params,
  });
}
