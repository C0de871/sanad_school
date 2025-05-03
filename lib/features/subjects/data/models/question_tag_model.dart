import '../../domain/entities/question_tag_entity.dart';

class QuestionTagModel extends QuestionTagEntity {
  static const String questionIdKey = 'question_id';
  static const String tagIdKey = 'tag_id';

  const QuestionTagModel({
    required super.questionId,
    required super.tagId,
  });

  factory QuestionTagModel.fromMap(Map<String, dynamic> map) {
    return QuestionTagModel(
      questionId: map[questionIdKey] as int,
      tagId: map[tagIdKey] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      questionIdKey: questionId,
      tagIdKey: tagId,
    };
  }
}
