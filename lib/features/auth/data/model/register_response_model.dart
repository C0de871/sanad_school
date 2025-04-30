import 'student_model.dart';

class AuthResponseModel {
  static const String dataKey = 'data';
  static const String messageKey = 'message';
  static const String statusKey = 'status';
  static const String accessTokenKey = 'access_token';

  final StudentModel student;
  final String message;
  final int status;
  final String accessToken;

  AuthResponseModel({
    required this.student,
    required this.message,
    required this.status,
    required this.accessToken,
  });

  factory AuthResponseModel.fromMap(Map<String, dynamic> map) {
    return AuthResponseModel(
      student: StudentModel.fromMap(map[dataKey]),
      message: map[messageKey],
      status: map[statusKey],
      accessToken: map[accessTokenKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      dataKey: student.toMap(),
      messageKey: message,
      statusKey: status,
      accessTokenKey: accessToken,
    };
  }
}
