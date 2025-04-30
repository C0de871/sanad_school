import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sanad_school/core/shared/widgets/my_place_holder.dart';
import '../../features/spalsh/presentation/spalsh_screen.dart';
import '../Routes/app_router.dart';
import '../Routes/app_routes.dart';
import '../helper/app_functions.dart';
import '../theme/theme.dart';
import '../utils/services/service_locator.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    getIt<AppTheme>().isDark = false;

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
      themeMode: ThemeMode.light,

      // initialRoute: AppRoutes.login,
      // initialRoute: AppRoutes.profile,
      initialRoute: AppRoutes.home,
      // home: SplashScreen(),
      // initialRoute: AppRoutes.home,
      // initialRoute: AppRoutes.quizSelection,
      onGenerateRoute: AppRouter().generateRoute,
      // home: BeautifulEquations(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return MyPlaceHolder();
  }
}
