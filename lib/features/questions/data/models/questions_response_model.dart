import 'question_model.dart';

class QuestionsResponseModel {
  static const String dataKey = 'data';
  static const String messageKey = 'message';
  static const String statusKey = 'status';

  final List<QuestionModel> questions;
  final String message;
  final int status;

  QuestionsResponseModel({
    required this.questions,
    required this.message,
    required this.status,
  });

  factory QuestionsResponseModel.fromMap(Map<String, dynamic> map) {
    return QuestionsResponseModel(
      questions: List<QuestionModel>.from(
        (map[dataKey] as List).map((e) => QuestionModel.fromMap(e)),
      ),
      message: map[messageKey],
      status: map[statusKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      dataKey: questions.map((e) => e.toMap()).toList(),
      messageKey: message,
      statusKey: status,
    };
  }
}
