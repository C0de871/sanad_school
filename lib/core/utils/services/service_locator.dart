import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sanad_school/features/lessons/data/data_sources/lessons_remote_data_source.dart';
import 'package:sanad_school/features/lessons/data/repo/lessons_repository_impl.dart';
import 'package:sanad_school/features/lessons/domain/repo/lessons_repository.dart';
import 'package:sanad_school/features/lessons/domain/use_cases/get_lessons_usecase.dart';
import 'package:sanad_school/features/questions/data/data_sources/question_remote_data_source.dart';
import 'package:sanad_school/features/questions/domain/repo/question_repository.dart';
import 'package:sanad_school/features/questions/domain/use_cases/get_questions_use_case.dart';
import 'package:sanad_school/features/subjects/data/data_sources/subject_remote_data_source.dart';
import 'package:sanad_school/features/subjects/domain/repo/subject_repository.dart';
import 'package:sanad_school/features/subjects/domain/use_cases/get_subjects_use_case.dart';
import '../../../features/questions/data/repo/question_repository_impl.dart';
import '../../../features/subjects/data/repository/subject_repository.dart';
import '../../databases/api/api_consumer.dart';
import '../../databases/api/dio_consumer.dart';
import '../../databases/cache/secure_storage_helper.dart';
import '../../databases/cache/shared_prefs_helper.dart';
import '../../databases/connection/network_info.dart';
import '../../theme/theme.dart';

final getIt = GetIt.instance; // Singleton instance of GetIt

void setupServicesLocator() {
  //!service:

  //! Core:
  getIt.registerLazySingleton<SharedPrefsHelper>(() => SharedPrefsHelper());
  getIt.registerLazySingleton<SecureStorageHelper>(() => SecureStorageHelper());
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: getIt()));
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoConnectivity(getIt()));
  getIt.registerLazySingleton<AppTheme>(() => AppTheme());

  //! Data Sources:
  getIt.registerLazySingleton<LessonsRemoteDataSource>(() => LessonsRemoteDataSource(api: getIt()));
  getIt.registerLazySingleton<QuestionRemoteDataSource>(() => QuestionRemoteDataSource(api: getIt()));
  getIt.registerLazySingleton<SubjectRemoteDataSource>(() => SubjectRemoteDataSource(api: getIt()));

  //! Repository:
  getIt.registerLazySingleton<LessonsRepository>(
    () => LessonsRepositoryImpl(
      networkInfo: getIt(),
      remoteDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<QuestionRepository>(
    () => QuestionRepositoryImpl(
      networkInfo: getIt(),
      remoteDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<SubjectRepository>(
    () => SubjectRepositoryImpl(
      networkInfo: getIt(),
      remoteDataSource: getIt(),
    ),
  );

  //! use cases:
  getIt.registerLazySingleton<GetLessonsUseCase>(() => GetLessonsUseCase(repository: getIt()));
  getIt.registerLazySingleton<GetQuestionsUseCase>(() => GetQuestionsUseCase(repository: getIt()));
  getIt.registerLazySingleton<GetSubjectsUseCase>(() => GetSubjectsUseCase(repository: getIt()));
}
