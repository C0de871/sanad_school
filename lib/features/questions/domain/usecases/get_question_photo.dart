import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:sanad_school/core/databases/errors/failure.dart';
import 'package:sanad_school/core/databases/params/params.dart';

import '../repo/question_repository.dart';

class GetQuestionPhoto {
  final QuestionRepository repository;

  GetQuestionPhoto({required this.repository});

  Future<Either<Failure, Uint8List?>> call(QuestionPhotoParams params) async {
    return repository.getQuestionPhoto(params: params);
  }
}

