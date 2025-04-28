import 'package:dartz/dartz.dart';
import '../../../../core/databases/connection/network_info.dart';
import '../../../../core/databases/errors/expentions.dart';
import '../../../../core/databases/errors/failure.dart';
import '../../../../core/databases/params/params.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/repo/question_repository.dart';
import '../data_sources/question_remote_data_source.dart';

class QuestionRepositoryImpl extends QuestionRepository {
  final NetworkInfo networkInfo;
  final QuestionRemoteDataSource remoteDataSource;

  QuestionRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<QuestionEntity>>> getLessonQuestions({
    required QuestionsInLessonWithTypeParams params,
  }) async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await remoteDataSource.getQuestions(
          params: params,
        );
        return Right(response.questions);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: "There is no internet connection"));
    }
  }
}
