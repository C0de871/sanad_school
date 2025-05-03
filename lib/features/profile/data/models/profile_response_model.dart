// lib/features/student/data/models/student_response_model.dart
import 'package:sanad_school/features/profile/data/models/profile_model.dart';

class ProfileResponseModel {
  static const String dataKey = 'data';
  static const String messageKey = 'message';
  static const String statusKey = 'status';

  final ProfileModel student;
  final String message;
  final int status;

  ProfileResponseModel({
    required this.student,
    required this.message,
    required this.status,
  });

  factory ProfileResponseModel.fromMap(Map<String, dynamic> map) {
    return ProfileResponseModel(
      student: ProfileModel.fromMap(map[dataKey]),
      message: map[messageKey],
      status: map[statusKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      dataKey: student.toMap(),
      messageKey: message,
      statusKey: status,
    };
  }
}
