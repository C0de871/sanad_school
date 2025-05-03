import 'code_model.dart';

class CheckCodeResponseModel {
  static const String dataKey = 'data';
  static const String messageKey = 'message';
  static const String statusKey = 'status';

  final CodeModel code;
  final String message;
  final int status;

  CheckCodeResponseModel({
    required this.code,
    required this.message,
    required this.status,
  });

  factory CheckCodeResponseModel.fromMap(Map<String, dynamic> map) {
    return CheckCodeResponseModel(
      code: CodeModel.fromMap(map[dataKey]),
      message: map[messageKey],
      status: map[statusKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      dataKey: code.toMap(),
      messageKey: message,
      statusKey: status,
    };
  }
}