import '../../../../core/databases/params/params.dart';
import '../../../questions/domain/entities/question_entity.dart';
import '../repository/quiz_repository.dart';

class GetQuizQuestionsUsecase {
  final QuizRepository repository;
  GetQuizQuestionsUsecase({required this.repository});

  Future<List<QuestionEntity>> call(QuizFilterParams params) async {
    return repository.getFilteredQuestions(params: params);
  }
}
