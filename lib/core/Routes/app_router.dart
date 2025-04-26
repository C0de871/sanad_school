import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_school/features/about_developers/presentation/about_developers_screen.dart';
import 'package:sanad_school/features/auth/presentation/cubit/obscure_cubit/obsecure_cubit.dart';
import 'package:sanad_school/features/auth/presentation/screens/personal_info/personal_info_screen.dart';
import 'package:sanad_school/features/auth/presentation/screens/school_info/school_info_screen.dart';
import 'package:sanad_school/features/questions/presentation/questions_screen.dart';
import 'package:sanad_school/features/reset_password/presentation/screens/enter_email_screen.dart';
import 'package:sanad_school/features/reset_password/presentation/screens/otp_screen.dart';
import 'package:sanad_school/features/reset_password/presentation/screens/reset_password_screen.dart';
import 'package:sanad_school/main.dart';

import '../../features/Q&A/presentation/questions_and_answers_screen.dart';
import '../../features/about_sanad/presentation/about_us_screen.dart';
import '../../features/auth/presentation/screens/login/login_screen.dart';
import '../shared/widgets/slide_transion_page_route_builder.dart';
import '../../features/lessons/presentation/lesson_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/randomize/data/mock_repository.dart';
import '../../features/randomize/presentation/cubits/quiz_selection_cubit.dart';
import '../../features/randomize/presentation/screens/quiz_selection/quiz_selection_screen.dart';
import '../../features/subjects/subjects_screen.dart';
import '../../features/subscription/presentation/subscription_screen.dart';
import 'app_routes.dart';

class AppRouter {
  //? <======= cubits declration =======>

  //? ||================ choose route ==================||
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //! login screen:
      case AppRoutes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (context) => ObsecureCubit(),
            child: LoginScreen(),
          ),
        );

      case AppRoutes.signUp:
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) => const PersonalInfoScreen(),
        );

      case AppRoutes.home:
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) => const HomeScreen(),
        );

      case AppRoutes.completeSignUp:
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) => SchoolInfoScreen(
            firstName: (settings.arguments as List)[0],
            lastName: (settings.arguments as List)[1],
            fatherName: (settings.arguments as List)[2],
          ),
        );
      case AppRoutes.lessons:
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) => LessonScreen(subject: settings.arguments as Subject),
        );

      case AppRoutes.questions:
        return SlidingPageRouteBuilder(
          settings: settings,
          builder: (context) {
            Subject subject = settings.arguments as Subject;
            String lessonName = subject.title;
            List<Question> sampleQuestions = subject.questions!;
            Color subjectColor = subject.color;
            return QuestionsPage(
              lessonName: lessonName,
              questions: sampleQuestions,
              subjectColor: subjectColor,
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
          builder: (context) => SubscriptionScreen(),
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
      case AppRoutes.quizSelection:
        return SlidingPageRouteBuilder(
          builder: (context) => BlocProvider(
            lazy: false,
            create: (context) => QuizSelectionCubit(
              questionRepository: MockQuestionRepository(),
            ),
            child: const QuizSelectionScreen(),
          ),
          settings: settings,
        );

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
