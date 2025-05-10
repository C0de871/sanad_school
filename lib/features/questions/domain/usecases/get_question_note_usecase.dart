import 'package:dartz/dartz.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../repo/question_repository.dart';

class GetQuestionNoteUseCase {
  final QuestionRepository repository;

  GetQuestionNoteUseCase(this.repository);

  Future<Either<Failure, String?>> call(GetQuestionNoteParams params) async {
    return await repository.getQuestionNote(params: params);
  }
}
