import '../../../../core/databases/params/params.dart';
import '../repository/quiz_repository.dart';
import '../../../tags/domain/entities/tag_entity.dart';

class GetAvailableTagsUsecase {
  final QuizRepository repository;
  GetAvailableTagsUsecase({required this.repository});

  Future<List<TagEntity>> call(GetAvailableTagsParams params) async {
    return repository.getAvailableTags(params: params);
  }
}
