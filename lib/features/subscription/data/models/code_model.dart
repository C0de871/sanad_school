import '../../domain/entities/code_entity.dart';

class CodeModel extends CodeEntity {
  static const String idKey = 'id';
  static const String codeKey = 'code';
  static const String subjectsKey = 'subjects';
  static const String expiresAtKey = 'expires_at';

  const CodeModel({
    super.id,
    super.code,
    super.subjects,
    super.expiresAt,
  });

  factory CodeModel.fromMap(Map<String, dynamic> map) {
    return CodeModel(
      id: map[idKey],
      code: map[codeKey],
      subjects: List<String>.from(map[subjectsKey] ?? []),
      expiresAt: map[expiresAtKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      codeKey: code,
      subjectsKey: subjects,
      expiresAtKey: expiresAt,
    };
  }
}
