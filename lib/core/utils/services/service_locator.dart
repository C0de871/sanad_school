import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:get_it/get_it.dart';
import 'package:sanad_school/core/utils/services/qr_service/qr_service.dart';
import 'package:sanad_school/core/utils/services/device_info_service.dart';
import 'package:sanad_school/features/auth/data/data%20sources/auth_local_data_source.dart';
import 'package:sanad_school/features/auth/data/data%20sources/auth_remote_data_source.dart';
import 'package:sanad_school/features/auth/domain/repository/auth_repository.dart';
import 'package:sanad_school/features/auth/domain/use_cases/delete_token_use_case.dart';
import 'package:sanad_school/features/auth/domain/use_cases/get_token_use_case.dart';
import 'package:sanad_school/features/auth/domain/use_cases/login_use_case.dart';
import 'package:sanad_school/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:sanad_school/features/auth/domain/use_cases/register_use_case.dart';
import 'package:sanad_school/features/auth/domain/use_cases/save_token_use_case.dart';
import 'package:sanad_school/features/lessons/data/data_sources/lessons_local_data_source.dart';
import 'package:sanad_school/features/lessons/data/data_sources/lessons_remote_data_source.dart';
import 'package:sanad_school/features/lessons/data/repo/lessons_repository_impl.dart';
import 'package:sanad_school/features/lessons/domain/repo/lessons_repository.dart';
import 'package:sanad_school/features/lessons/domain/use_cases/get_lessons_usecase.dart';
import 'package:sanad_school/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:sanad_school/features/profile/domain/repo/profile_repo.dart';
import 'package:sanad_school/features/profile/domain/use_cases/get_student_profile_use_case.dart';
import 'package:sanad_school/features/questions/data/data_sources/question_local_data_source.dart';
import 'package:sanad_school/features/questions/data/data_sources/question_remote_data_source.dart';
import 'package:sanad_school/features/questions/domain/repo/question_repository.dart';
import 'package:sanad_school/features/questions/domain/use_cases/get_questions_in_lesson_by_type_use_case.dart';
import 'package:sanad_school/features/subject_type/data/data_sources/type_remote_data_source.dart';
import 'package:sanad_school/features/subject_type/domain/repo/type_repository.dart';
import 'package:sanad_school/features/subject_type/domain/use_cases/get_types_use_case.dart';
import 'package:sanad_school/features/subjects/data/data_sources/subject_remote_data_source.dart';
import 'package:sanad_school/features/subjects/domain/repo/subject_repository.dart';
import 'package:sanad_school/features/subjects/domain/use_cases/get_subjects_use_case.dart';
import 'package:sanad_school/features/tags/data/data_sources/tag_local_data_source.dart';
import 'package:sanad_school/features/tags/domain/use_cases/get_tags_or_exams.dart';
import '../../../features/auth/data/repository/auth_repository_imple.dart';
import '../../../features/profile/data/repo/profile_repo_impl.dart';
import '../../../features/questions/data/repo/question_repository_impl.dart';
import '../../../features/questions/domain/use_cases/get_questions_in_subject_by_tag.dart';
import '../../../features/subject_type/data/repo/repositories/type_repository_impl.dart';
import '../../../features/subjects/data/data_sources/subject_local_data_source.dart';
import '../../../features/subjects/data/repository/subject_repository.dart';
import '../../../features/tags/data/data_sources/tag_remote_data_source.dart';
import '../../../features/tags/data/repo/tag_repository_impl.dart';
import '../../../features/tags/domain/repo/tag_repository.dart';
import '../../databases/api/api_consumer.dart';
import '../../databases/api/auth_interceptor.dart';
import '../../databases/api/dio_consumer.dart';
import '../../databases/cache/secure_storage_helper.dart';
import '../../databases/cache/shared_prefs_helper.dart';
import '../../databases/connection/network_info.dart';
import '../../databases/local_database/sql_db.dart';
import '../../theme/theme.dart';
import '../../../features/subjects/domain/use_cases/get_subject_sync_use_case.dart';

final getIt = GetIt.instance; // Singleton instance of GetIt

void setupServicesLocator() {
  //!service:

  //! Core:
  getIt.registerLazySingleton<SharedPrefsHelper>(() => SharedPrefsHelper()..init());
  getIt.registerLazySingleton<SecureStorageHelper>(() => SecureStorageHelper());
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: getIt()));
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoConnectivity(getIt()));
  getIt.registerLazySingleton<AppTheme>(() => AppTheme());
  getIt.registerLazySingleton<QrCodeScannerService>(() => QrCodeScannerService());
  getIt.registerLazySingleton<DeviceInfoService>(() => DeviceInfoService());
  getIt.registerLazySingleton<SqlDB>(() => SqlDB());

  //! Data Sources:
  getIt.registerLazySingleton<LessonsRemoteDataSource>(() => LessonsRemoteDataSource(api: getIt()));
  getIt.registerLazySingleton<QuestionRemoteDataSource>(() => QuestionRemoteDataSource(api: getIt()));
  getIt.registerLazySingleton<SubjectRemoteDataSource>(() => SubjectRemoteDataSource(api: getIt()));
  getIt.registerLazySingleton<TagRemoteDataSource>(() => TagRemoteDataSource(api: getIt()));
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(api: getIt()));
  getIt.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSource(secureStorage: getIt()));
  getIt.registerLazySingleton<TypeRemoteDataSource>(() => TypeRemoteDataSource(api: getIt()));
  getIt.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSource(api: getIt()));

  //! local date soures:
  getIt.registerLazySingleton<SubjectLocalDataSource>(() => SubjectLocalDataSourceImpl(database: getIt()));
  getIt.registerLazySingleton<LessonsLocalDataSource>(() => LessonsLocalDataSource(database: getIt()));
  getIt.registerLazySingleton<QuestionLocalDataSource>(() => QuestionLocalDataSource(database: getIt()));
  getIt.registerLazySingleton<TagLocalDataSource>(() => TagLocalDataSource(database: getIt()));

  //! Repository:
  getIt.registerLazySingleton<LessonsRepository>(
    () => LessonsRepositoryImpl(
      networkInfo: getIt(),
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<QuestionRepository>(
    () => QuestionRepositoryImpl(
      networkInfo: getIt(),
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<SubjectRepository>(
    () => SubjectRepositoryImpl(
      networkInfo: getIt(),
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<TagRepository>(
    () => TagRepositoryImpl(
      networkInfo: getIt(),
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      networkInfo: getIt(),
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<TypeRepository>(
    () => TypeRepositoryImpl(
      networkInfo: getIt(),
      remoteDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      networkInfo: getIt(),
      remoteDataSource: getIt(),
    ),
  );

  //! use cases:
  getIt.registerLazySingleton<GetLessonsUseCase>(() => GetLessonsUseCase(repository: getIt()));
  getIt.registerLazySingleton<GetQuestionsInLessonByTypeUseCase>(() => GetQuestionsInLessonByTypeUseCase(repository: getIt()));
  getIt.registerLazySingleton<GetSubjectsUseCase>(() => GetSubjectsUseCase(repository: getIt()));
  getIt.registerLazySingleton<GetTagsOrExamsUseCase>(() => GetTagsOrExamsUseCase(repository: getIt()));
  getIt.registerLazySingleton<GetQuestionsInSubjectByTagUseCase>(() => GetQuestionsInSubjectByTagUseCase(repository: getIt()));
  getIt.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(repository: getIt()));
  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(repository: getIt()));
  getIt.registerLazySingleton<GetTokenUseCase>(() => GetTokenUseCase(repository: getIt()));
  getIt.registerLazySingleton<SaveTokenUseCase>(() => SaveTokenUseCase(repository: getIt()));
  getIt.registerLazySingleton<DeleteTokenUseCase>(() => DeleteTokenUseCase(repository: getIt()));
  getIt.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(repository: getIt()));
  getIt.registerLazySingleton<GetTypesUseCase>(() => GetTypesUseCase(repository: getIt()));
  getIt.registerLazySingleton<GetStudentProfileUseCase>(() => GetStudentProfileUseCase(repository: getIt()));
  getIt.registerLazySingleton<GetSubjectSyncUseCase>(() => GetSubjectSyncUseCase(repository: getIt()));

  //! Interceptors:
  getIt.registerLazySingleton<AuthInterceptor>(() => AuthInterceptor(retrieveAccessTokenUseCase: getIt()));
}

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  TeXRederingServer.renderingEngine = const TeXViewRenderingEngine.mathjax();
  if (!kIsWeb) {
    await TeXRederingServer.run();
    await TeXRederingServer.initController();
  }
  await dotenv.load(fileName: ".env");
  setupServicesLocator();
  final SqlDB sqlDb = getIt<SqlDB>();
  await sqlDb.deleteDB();
  await sqlDb.initialDb();
  await (getIt<ApiConsumer>() as DioConsumer).addInterceptors(getIt<AuthInterceptor>());
  // await FireBaseService.initializeApp();

  // await FireBaseService().initNotifications();
}
