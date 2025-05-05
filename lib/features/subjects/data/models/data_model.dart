import '../../../lessons/data/models/question_type_model.dart';
import 'subject_model.dart';

class DataModel {
  static const String subjectsKey = 'subjects';
  static const String questionTypesKey = 'question_types';

  final List<SubjectModel> subjects;
  final List<QuestionTypeModel> questionTypes;

  DataModel({required this.subjects, required this.questionTypes});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      subjects: (json[subjectsKey] as List).map((e) => SubjectModel.fromMap(e)).toList(),
      questionTypes: (json[questionTypesKey] as List).map((e) => QuestionTypeModel.fromMap(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      subjectsKey: subjects.map((e) => e.toMap()).toList(),
      questionTypesKey: questionTypes.map((e) => e.toMap()).toList(),
    };
  }
}
