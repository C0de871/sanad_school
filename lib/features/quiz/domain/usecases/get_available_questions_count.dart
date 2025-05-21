import '../../../../core/databases/params/params.dart';
import '../repository/quiz_repository.dart';

class GetAvailableQuestionsCountUsecase {
  final QuizRepository repository;
  GetAvailableQuestionsCountUsecase({required this.repository});

  Future<int> call(QuizFilterParams params) async {
    return repository.getFilteredQuestionsCounts(params: params);
  }
}
