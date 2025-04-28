import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../params/params.dart';

class EndPoints {
  static String baseUrl = dotenv.get('BASEURL');
  static String subject = dotenv.get('SUBJECT');
  static String lessonEndpoint(int subjectId) {
    return '$baseUrl$subject/$subjectId/lessons';
  }

  static String questionInLessonWithType({required QuestionsInLessonWithTypeParams params}) {
    // "${EndPoints.lesson}/$lessonId/questions/$typeId"
    return '${baseUrl}lesson/${params.lessonId}/questions/${params.typeId}';
  }

  static const String templateT = "";
}

class ApiKey {
  static String currentPage = "";

  static String totalPages = "";

  static String totalItems = "";

  static String hasMorePage = "";

  static String message = "";

  static String statusCode = "";
}
