import 'subject_model.dart';

class SubjectResponseModel {
  static const String dataKey = 'data';
  static const String messageKey = 'message';
  static const String statusKey = 'status';

  final List<SubjectModel> subjects;
  final String message;
  final int status;

  SubjectResponseModel({
    required this.subjects,
    required this.message,
    required this.status,
  });

  factory SubjectResponseModel.fromMap(Map<String, dynamic> map) {
    return SubjectResponseModel(
      subjects: List<SubjectModel>.from(
        (map[dataKey] as List).map((e) => SubjectModel.fromMap(e)),
      ),
      message: map[messageKey],
      status: map[statusKey],
    );
  }
    
  Map<String, dynamic> toMap() {
    return {
      dataKey: subjects.map((e) => e.toMap()).toList(),
      messageKey: message,
      statusKey: status,
    };
  }
}
