// lib/features/subject/data/models/tag_response_model.dart
import 'tag_model.dart';

class TagResponseModel {
  static const String dataKey = 'data';
  static const String messageKey = 'message';
  static const String statusKey = 'status';

  final List<TagModel> tags;
  final String message;
  final int status;

  TagResponseModel({
    required this.tags,
    required this.message,
    required this.status,
  });

  factory TagResponseModel.fromMap(Map<String, dynamic> map) {
    return TagResponseModel(
      tags: List<TagModel>.from(
        (map[dataKey] as List).map((e) => TagModel.fromMap(e)),
      ),
      message: map[messageKey],
      status: map[statusKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      dataKey: tags.map((e) => e.toMap()).toList(),
      messageKey: message,
      statusKey: status,
    };
  }
}