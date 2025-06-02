import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../params/params.dart';

class EndPoints {
  static String baseUrl = dotenv.get('BASEURL');
  static String subject = dotenv.get('SUBJECT');
  static const String register = 'auth/register';
  static const String login = 'auth/login';
  static const String types = 'type';
  static const String studentProfile = 'auth/profile/';
  static const String logout = 'auth/logout';
  static const String check = 'code/check';
  static const String code = 'code';

  static String subjectSyncEndpoint(int subjectId) {
    return '${baseUrl}subject/$subjectId/sync';
  }

  static String lessonEndpoint(int subjectId) {
    return '${baseUrl}subject/$subjectId/lessons';
  }

  static String questionInLessonWithType(
      {required QuestionsInLessonWithTypeParams params}) {
    // "${EndPoints.lesson}/$lessonId/questions/$typeId"
    if (params.typeId == null) {
      return '${baseUrl}lesson/${params.lessonId}/questions';
    }
    return '${baseUrl}lesson/${params.lessonId}/questions/${params.typeId}';
  }

  static String questionInSubjectbByTag(
      {required QuestionsInSubjectByTag params}) {
    return '${baseUrl}tag/${params.tagId}/questions';
  }

  static String getTagsOrExamsEndpoint(int subjectId, bool isExam) {
    return '${baseUrl}subject/$subjectId/${isExam ? 'exams' : 'tags'}';
  }

  static const String templateT = "";
}

class ApiKey {
  static String currentPage = "";
  static String totalPages = "";
  static String totalItems = "";
  static String hasMorePage = "";
  static String message = "message";
  static String statusCode = "";
  static String data = "data";
}
