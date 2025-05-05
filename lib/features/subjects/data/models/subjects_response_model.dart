

import 'data_model.dart';

class SubjectResponseModel {
  static const String dataKey = 'data';
  static const String messageKey = 'message';
  static const String statusKey = 'status';

  final String message;
  final int status;
  final DataModel data;

  SubjectResponseModel({
    required this.message,
    required this.status,
    required this.data,
  });

  factory SubjectResponseModel.fromMap(Map<String, dynamic> map) {
    return SubjectResponseModel(
      // subjects: List<SubjectModel>.from(
      //   (map[dataKey] as List).map((e) => SubjectModel.fromMap(e)),
      // ),
      // questionTypes: List<QuestionTypeModel>.from(
      //   (map[dataKey] as List).map((e) => QuestionTypeModel.fromMap(e)),
      // ),
      data: DataModel.fromJson(map[dataKey]),
      message: map[messageKey],
      status: map[statusKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      dataKey: data.toJson(),
      messageKey: message,
      statusKey: status,
    };
  }
}
