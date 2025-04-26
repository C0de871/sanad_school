// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:sanad_school/core/databases/local_database/sql_db.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/app/app.dart';
import 'core/databases/cache/shared_prefs_helper.dart';
import 'core/utils/services/service_locator.dart';
import 'features/questions/presentation/questions_screen.dart';
// import 'features/questions/temp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TeXRederingServer.renderingEngine = const TeXViewRenderingEngine.mathjax();

  if (!kIsWeb) {
    await TeXRederingServer.run();
    await TeXRederingServer.initController();
  }
  await dotenv.load(fileName: ".env");
  setupServicesLocator();
  await getIt<SharedPrefsHelper>().init();
  final SqlDB sqlDb = SqlDB();
  await sqlDb.initalDB();
  // await FireBaseService.initializeApp();

  // await FireBaseService().initNotifications();
  runApp(const MyApp());
}

class Subject {
  final String title;
  final IconData icon;
  final String description;
  final Color color;
  final double completePercentage;
  final int lessonCount;
  final List<Question>? questions;

  Subject({
    required this.title,
    required this.icon,
    required this.description,
    required this.color,
    this.completePercentage = 23,
    this.lessonCount = 19,
    this.questions,
  });
}
