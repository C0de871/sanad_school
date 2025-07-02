// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'core/app/app.dart';
import 'core/utils/services/service_locator.dart';
// import 'features/questions/temp.dart';

final _noScreenshot = NoScreenshot.instance;
Future<void> disableScreenshot() async {
  bool result = await _noScreenshot.screenshotOff();
  debugPrint('Screenshot Off: $result');
}

//enable

Future<void> enableScreenshot() async {
  bool result = await _noScreenshot.screenshotOn();
  debugPrint('Screenshot On: $result');
}

void main() async {
  await initApp();
  // await disableScreenshot();
  // final logFile = await _getLogFile();
  // final logSink = logFile.openWrite(mode: FileMode.append);

  // // Catch Flutter errors
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   FlutterError.dumpErrorToConsole(details);
  //   logSink.writeln('--- FLUTTER ERROR ---');
  //   logSink.writeln(details.exceptionAsString());
  //   logSink.writeln(details.stack.toString());
  //   logSink.flush();
  // };

  // Catch Dart (non-Flutter) errors
  runApp(const MyApp());
  // runZonedGuarded(() async {}, (error, stackTrace) {
  //   logSink.writeln('--- ZONED ERROR ---');
  //   logSink.writeln(error.toString());
  //   logSink.writeln(stackTrace.toString());
  //   logSink.flush();
  // });
}

Future<File> _getLogFile() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/debug_log.txt');
  if (!(await file.exists())) {
    await file.create();
  }
  return file;
}
