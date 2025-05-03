class LogoutResponseModel {
  static const String dataKey = 'data';
  static const String messageKey = 'message';
  static const String statusKey = 'status';

  final dynamic data;
  final String message;
  final int status;

  LogoutResponseModel({
    required this.data,
    required this.message,
    required this.status,
  });

  factory LogoutResponseModel.fromMap(Map<String, dynamic> map) {
    return LogoutResponseModel(
      data: map[dataKey],
      message: map[messageKey],
      status: map[statusKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      dataKey: data,
      messageKey: message,
      statusKey: status,
    };
  }
}
