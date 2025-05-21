import '../../../../core/databases/params/params.dart';
import '../repository/quiz_repository.dart';
import '../../../lessons/domain/entities/lesson_entity.dart';

class GetAvailableLessonsUsecase {
  final QuizRepository repository;
  GetAvailableLessonsUsecase({required this.repository});

  Future<List<LessonEntity>> call(GetAvailableLessonsParams params) async {
    return repository.getAvailableLessons(params: params);
  }
}
