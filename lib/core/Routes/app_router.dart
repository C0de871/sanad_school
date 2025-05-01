import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_school/core/utils/services/qr_service/qr_result.dart';
import 'package:sanad_school/core/utils/services/qr_service/qr_screen.dart';
import 'package:sanad_school/features/about_developers/presentation/about_developers_screen.dart';
import 'package:sanad_school/features/auth/presentation/cubit/obscure_cubit/obsecure_cubit.dart';
import 'package:sanad_school/features/auth/presentation/screens/personal_info/personal_info_screen.dart';
import 'package:sanad_school/features/auth/presentation/screens/school_info/school_info_screen.dart';
import 'package:sanad_school/features/lessons/presentation/cubit/lessons_cubit.dart';
import 'package:sanad_school/features/questions/presentation/cubit/question_cubit.dart';
import 'package:sanad_school/features/questions/presentation/questions_screen.dart';
import 'package:sanad_school/features/reset_password/presentation/screens/enter_email_screen.dart';
import 'package:sanad_school/features/reset_password/presentation/screens/otp_screen.dart';
import 'package:sanad_school/features/reset_password/presentation/screens/reset_password_screen.dart';
import 'package:sanad_school/features/subjects/domain/entities/subject_entity.dart';
import 'package:sanad_school/features/subjects/presentation/cubit/subject_cubit.dart';
import 'package:sanad_school/features/subscription/presentation/cubits/subscription_cubit.dart';
import 'package:sanad_school/features/tags/domain/entities/tag_entity.dart';
import 'package:sanad_school/features/tags/presentation/cubits/tag_cubit.dart';
import 'package:sanad_school/main.dart';

import '../../features/Q&A/presentation/questions_and_answers_screen.dart';
import '../../features/about_sanad/presentation/about_us_screen.dart';
import '../../features/auth/presentation/cubit/auth_cubit/auth_cubit.dart';
import '../../features/auth/presentation/screens/login/login_screen.dart';
import '../../features/lessons/domain/entities/lesson_with_one_type_entity.dart';
import '../helper/cubit_helper.dart';
import '../shared/widgets/slide_transion_page_route_builder.dart';
import '../../features/lessons/presentation/lesson_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
// import '../../features/randomize/data/mock_repository.dart';
// import '../../features/randomize/presentation/cubits/quiz_selection_cubit.dart';
// import '../../features/randomize/presentation/screens/quiz_selection/quiz_selection_screen.dart';
import '../../features/subjects/subjects_screen.dart';
import '../../features/subscription/presentation/subscription_screen.dart';
import 'app_routes.dart';

class AppRouter with CubitProviderMixin {
  //? <======= cubits declration =======>
  static const String tagCubitKey = "tags-cubit";
  static const String examTagCubitKey = "exam-tag-cubit";

  //? ||================ choose route ==================||
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //! login screen:
      case AppRoutes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ObsecureCubit(),
              ),
              BlocProvider(
                create: (context) => getCubit(() => AuthCubit()),
              ),
            ],
            child: LoginScreen(),
          ),
        );

      case AppRoutes.signUp:
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) => BlocProvider.value(
            value: getCubit(() => AuthCubit()),
            child: const PersonalInfoScreen(),
          ),
        );

      case AppRoutes.home:
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => getCubit(() => SubjectCubit())..getSubjects(),
            child: const HomeScreen(),
          ),
        );

      case AppRoutes.completeSignUp:
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) => BlocProvider.value(
            value: getCubit(() => AuthCubit()),
            child: SchoolInfoScreen(),
          ),
        );
      case AppRoutes.subjectDetails:
        final arg = settings.arguments as Map;
        final SubjectEntity subject = arg["subject"];
        final Color color = arg["color"];
        final TextDirection textDirection = arg["direction"];
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                lazy: false,
                create: (context) {
                  return getCubit(() => LessonsCubit())..getLessons(subject.id);
                },
              ),
            ],
            child: SubjectDetailsScreen(
              subject: subject,
              color: color,
              textDirection: textDirection,
            ),
          ),
        );

      case AppRoutes.questions:
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) {
            final arg = settings.arguments as Map;
            final LessonWithOneTypeEntity lessonWithOneTypeEntity = arg["lesson"];
            final SubjectEntity subject = arg["subject"];
            final Color subjectColor = arg["color"];
            final TextDirection textDirection = arg["direction"];
            return BlocProvider(
              create: (context) => getCubit(() => QuestionCubit())
                ..getQuestionsByLessonAndType(
                  lessonId: lessonWithOneTypeEntity.id,
                  typeId: lessonWithOneTypeEntity.questionType.id,
                ),
              child: QuestionsPage(
                subjectColor: subjectColor,
                lessonName: lessonWithOneTypeEntity.title,
                textDirection: textDirection,
              ),
            );
          },
        );
      case AppRoutes.questionsFromTag:
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) {
            final arg = settings.arguments as Map;
            final Color subjectColor = arg["color"];
            final TagEntity tag = arg['tag'];
            final TextDirection direction = arg['direction'];
            return BlocProvider(
              create: (context) => getCubit(() => QuestionCubit())
                ..getSubjectQuestionsByTag(
                  tagId: tag.id,
                ),
              child: QuestionsPage(
                subjectColor: subjectColor,
                lessonName: tag.name,
                textDirection: direction,
              ),
            );
          },
        );
      case AppRoutes.profile:
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) => const ProfileScreen(),
        );

      case AppRoutes.subscription:
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => getCubit(() => SubscriptionCubit()),
            child: SubscriptionScreen(),
          ),
        );

      case AppRoutes.aboutSanad:
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) => AboutScreen(),
        );
      case AppRoutes.aboutDevelopers:
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) => AboutDeveloperScreen(),
        );

      case AppRoutes.questionsAndAnswers:
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) => FAQScreen(),
        );

      case AppRoutes.enterEmail:
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) => EnterEmailScreen(),
        );
      case AppRoutes.otp:
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) => OtpScreen(),
        );
      case AppRoutes.resetPasswrod:
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) => ResetPasswordScreen(),
        );
      case AppRoutes.qrScanner:
        return SlidingPageRouteBuilder<QrCodeResult?>(
          settings: settings,
          builder: (context) => QrScannerScreen(),
        );
      // case AppRoutes.quizSelection:
      //   return SlidingPageRouteBuilder(
      //     builder: (context) => BlocProvider(
      //       lazy: false,
      //       create: (context) => QuizSelectionCubit(
      //         questionRepository: MockQuestionRepository(),
      //       ),
      //       child: const QuizSelectionScreen(),
      //     ),
      //     settings: settings,
      //   );

      //!default route:
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                "No route defined for ${settings.name}",
              ),
            ),
          ),
        );
    }
  }
}
