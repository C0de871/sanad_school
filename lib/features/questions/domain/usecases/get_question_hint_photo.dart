import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../repo/question_repository.dart';

class GetQuestionHintPhoto {
  final QuestionRepository repository;

  GetQuestionHintPhoto({required this.repository});

  Future<Either<Failure, Uint8List?>> call(QuestionPhotoParams params) async {
    return repository.getQuestionHintPhoto(params: params);
  }
}
