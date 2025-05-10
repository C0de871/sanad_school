import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../repo/question_repository.dart';

class SaveQuestionNoteUseCase {
  final QuestionRepository repository;

  SaveQuestionNoteUseCase(this.repository);

  Future<Either<Failure, bool>> call(SaveQuestionNoteParams params) async {
    return await repository.saveQuestionNote(params: params);
  }
}
