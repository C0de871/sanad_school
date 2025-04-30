import 'type_model.dart';

class TypeResponseModel {
  static const String dataKey = 'data';
  static const String messageKey = 'message';
  static const String statusKey = 'status';

  final List<TypeModel> types;
  final String message;
  final int status;

  TypeResponseModel({
    required this.types,
    required this.message,
    required this.status,
  });

  factory TypeResponseModel.fromMap(Map<String, dynamic> map) {
    return TypeResponseModel(
      types: List<TypeModel>.from(
        (map[dataKey] as List).map((e) => TypeModel.fromMap(e)),
      ),
      message: map[messageKey],
      status: map[statusKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      dataKey: types.map((e) => e.toMap()).toList(),
      messageKey: message,
      statusKey: status,
    };
  }
}