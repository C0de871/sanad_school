import 'package:equatable/equatable.dart';
import 'package:sanad_school/features/subjects/domain/entities/question_group_entity.dart';
import '../../../subject_type/domain/entities/type_entity.dart';
import '../entities/subject_entity.dart';
import '../entities/question_tag_entity.dart';
import '../entities/lesson_entity.dart';
import 'question_entity.dart';
import 'tag_entity.dart';

class SubjectSyncEntity extends Equatable {
  final SubjectEntity subject;
  final List<LessonEntity> lessons;
  final List<QuestionGroupEntity> questionGroups;
  final List<QuestionEntity> questions;
  final List<TagEntity> tags;
  final List<QuestionTagEntity> questionTags;
  final List<TypeEntity> types;

  const SubjectSyncEntity({
    required this.subject,
    required this.lessons,
    required this.questionGroups,
    required this.questions,
    required this.tags,
    required this.questionTags,
    required this.types,
  });

  @override
  List<Object?> get props => [
        subject,
        lessons,
        questionGroups,
        questions,
        tags,
        questionTags,
        types,
      ];
}
