import 'package:equatable/equatable.dart';

class QuestionTypeEntity extends Equatable {
  final int id;
  final String name;

  const QuestionTypeEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
