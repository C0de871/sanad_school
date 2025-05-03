import 'code_data_model.dart';

class CodeResponseModel {
  static const String dataKey = 'data';
  static const String messageKey = 'message';
  static const String statusKey = 'status';

  final CodeDataModel data;
  final String message;
  final int status;

  CodeResponseModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory CodeResponseModel.fromMap(Map<String, dynamic> map) {
    return CodeResponseModel(
      data: CodeDataModel.fromMap(map[dataKey]),
      message: map[messageKey],
      status: map[statusKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      dataKey: data.toMap(),
      messageKey: message,
      statusKey: status,
    };
  }
}