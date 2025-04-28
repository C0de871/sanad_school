// lib/features/subject/domain/entities/tag_entity.dart
import 'package:equatable/equatable.dart';

class TagEntity extends Equatable {
  final int id;
  final String name;
  final int subjectId;
  final bool isExam;

  const TagEntity({
    required this.id,
    required this.name,
    required this.subjectId,
    required this.isExam,
  });

  @override
  List<Object?> get props => [id, name, subjectId, isExam];
}