// lib/features/lessons/data/models/lessons_response_model.dart
import 'lesson_model.dart';

class LessonsResponseModel {
  static const String dataKey = 'data';
  static const String messageKey = 'message';
  static const String statusKey = 'status';

  final List<LessonModel> lessons;
  final String message;
  final int status;

  LessonsResponseModel({
    required this.lessons,
    required this.message,
    required this.status,
  });

  factory LessonsResponseModel.fromMap(Map<String, dynamic> map) {
    return LessonsResponseModel(
      lessons: List<LessonModel>.from(
        (map[dataKey] as List).map((e) => LessonModel.fromMap(e)),
      ),
      message: map[messageKey],
      status: map[statusKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      dataKey: lessons.map((e) => e.toMap()).toList(),
      messageKey: message,
      statusKey: status,
    };
  }
}
