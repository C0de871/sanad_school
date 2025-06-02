// lib/features/lessons/data/models/lessons_response_model.dart
import 'dart:developer';

import '../../domain/entities/lessons_response_entity.dart';
import 'lesson_model.dart';

class LessonsResponseModel extends LessonsResponseEntity {
  static const String dataKey = 'data';
  static const String messageKey = 'message';
  static const String statusKey = 'status';
  static const String totalQuestionsKey = 'total_questions_key';
  static const String totalAnsweredQuestionsKey =
      'total_answered_questions_key';

  LessonsResponseModel({
    required super.lessons,
    required super.message,
    required super.status,
    super.totalQuestions,
    super.totalAnsweredQuestions,
  });

  factory LessonsResponseModel.fromMap(Map<String, dynamic> map) {
    log("from map: ${map[dataKey].toString()}");
    return LessonsResponseModel(
      lessons: List<LessonModel>.from(
        (map[dataKey] as List).map((e) => LessonModel.fromMap(e)),
      ),
      message: map[messageKey],
      status: map[statusKey],
      totalQuestions: (map[totalQuestionsKey] as int?) == 0
          ? 1
          : (map[totalQuestionsKey] as int? ?? 1),
      totalAnsweredQuestions: map[totalAnsweredQuestionsKey] as int? ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      dataKey: lessons.map((e) => (e as LessonModel).toMap()).toList(),
      messageKey: message,
      statusKey: status,
      totalQuestionsKey: totalQuestions,
      totalAnsweredQuestionsKey: totalAnsweredQuestions,
    };
  }
}
