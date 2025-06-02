import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sanad_school/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:sanad_school/features/subjects/presentation/cubit/subject_cubit.dart';
import '../Routes/app_router.dart';
import '../helper/app_functions.dart';
import 'package:secure_application/secure_application.dart';

import '../theme/theme.dart';
import '../utils/services/service_locator.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit()..getTheme(),
        ),
        BlocProvider(
          create: (context) => SubjectCubit()..getSubjects(),
        )
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          getIt<AppTheme>().isDark =
              state.themeMode == ThemeMode.dark ? true : false;

          return MaterialApp(
            navigatorObservers: [RouteObserverService()],
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar', ''),
              Locale('en', ''),
            ],
            locale: const Locale('ar', ''),
            title: 'Sanad School',
            theme: getIt<AppTheme>().light(),
            darkTheme: getIt<AppTheme>().dark(),
            themeMode: state.themeMode,
            // builder: (context, child) {
            //   return SecureApplication(
            //     nativeRemoveDelay: 100,
            //     onNeedUnlock: (secureApplicationController) async {
            //       return SecureApplicationAuthenticationStatus.SUCCESS;
            //     },
            //     child: SecureGate(
            //       blurr: 20,
            //       opacity: 0.6,
            //       child: child ?? SizedBox(),
            //     ),
            //   );
            // },

            // initialRoute: AppRoutes.login,
            // initialRoute: AppRoutes.profile,
            // initialRoute: AppRoutes.home,
            // home: SplashScreen(),
            // initialRoute: AppRoutes.home,
            // initialRoute: AppRoutes.quizSelection,
            // initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRouter().generateRoute,
            // home:
            // home: BeautifulEquations(),
          );
        },
      ),
    );
  }
}
