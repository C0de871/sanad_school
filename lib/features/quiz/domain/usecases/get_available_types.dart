import '../../../../core/databases/params/params.dart';
import '../repository/quiz_repository.dart';
import '../../../lessons/domain/entities/question_type_entity.dart';

class GetAvailableTypesUsecase {
  final QuizRepository repository;
  GetAvailableTypesUsecase({required this.repository});

  Future<List<QuestionTypeEntity>> call(GetAvailableTypesParams params) async {
    return repository.getAvailableTypes(params: params);
  }
}
