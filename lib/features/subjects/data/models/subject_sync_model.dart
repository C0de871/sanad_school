import '../../../subject_type/data/models/type_model.dart';
import '../../domain/entities/subject_sync_entity.dart';
import 'subject_model.dart';
import 'lesson_model.dart';
import 'question_group_model.dart';
import 'question_model.dart';
import 'tag_model.dart';
import 'question_tag_model.dart';

class SubjectSyncModel extends SubjectSyncEntity {
  static const String dataKey = 'data';
  static const String subjectsKey = 'subjects';
  static const String lessonsKey = 'lessons';
  static const String questionGroupsKey = 'question_groups';
  static const String questionsKey = 'questions';
  static const String tagsKey = 'tags';
  static const String questionTagsKey = 'question_tags';
  static const String typesKey = 'question_type';

  const SubjectSyncModel({
    required super.subject,
    required super.lessons,
    required super.questionGroups,
    required super.questions,
    required super.tags,
    required super.questionTags,
    required super.types,
  });

  factory SubjectSyncModel.fromMap(Map<String, dynamic> map) {
    final data = map[dataKey] as Map<String, dynamic>;
    return SubjectSyncModel(
      subject: SubjectModel.fromMap(data[subjectsKey]),
      lessons: (data[lessonsKey] as List).map((lesson) => LessonModel.fromMap(lesson)).toList(),
      questionGroups: (data[questionGroupsKey] as List).map((group) => QuestionGroupModel.fromMap(group)).toList(),
      questions: (data[questionsKey] as List).map((question) => QuestionModel.fromMap(question)).toList(),
      tags: (data[tagsKey] as List).map((tag) => TagModel.fromMap(tag)).toList(),
      questionTags: (data[questionTagsKey] as List).map((tag) => QuestionTagModel.fromMap(tag)).toList(),
      types: (data[typesKey] as List).map((type) => TypeModel.fromMap(type)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      dataKey: {
        subjectsKey: (subject as SubjectModel).toMap(),
        lessonsKey: lessons.map((lesson) => (lesson as LessonModel).toMap()).toList(),
        questionGroupsKey: questionGroups.map((group) => (group as QuestionGroupModel).toMap()).toList(),
        questionsKey: questions.map((question) => (question as QuestionModel).toMap()).toList(),
        tagsKey: tags.map((tag) => (tag as TagModel).toMap()).toList(),
        questionTagsKey: questionTags.map((tag) => (tag as QuestionTagModel).toMap()).toList(),
        typesKey: types.map((type) => (type as TypeModel).toMap()).toList(),
      }
    };
  }
}
