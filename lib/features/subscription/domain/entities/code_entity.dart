import 'package:equatable/equatable.dart';

class CodeEntity extends Equatable {
  final int? id;
  final String? code;
  final List<String>? subjects;
  final String? expiresAt;

  const CodeEntity({
    this.id,
    this.code,
    this.subjects,
    this.expiresAt,
  });

  @override
  List<Object?> get props => [id, code, subjects, expiresAt];
}
