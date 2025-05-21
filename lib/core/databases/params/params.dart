abstract class Params {}

class NoParams extends Params {}

class NoBody {}

class TemplateTParams extends Params {}

// lib/features/lessons/data/params/lessons_params.dart
class LessonsParams {
  final int subjectId;

  LessonsParams({required this.subjectId});
}

class QuestionsInLessonWithTypeParams {
  final int lessonId;
  final int? typeId;

  QuestionsInLessonWithTypeParams({required this.lessonId, required this.typeId});
}

class QuestionsInSubjectByTag {
  final int tagId;

  QuestionsInSubjectByTag({required this.tagId});
}

class TagParams {
  final int subjectId;
  final bool isExam;

  TagParams({
    required this.subjectId,
    required this.isExam,
  });
}

class CodeBody {
  final String code;
  static const String codeKey = 'code';

  CodeBody({required this.code});

  Map<String, dynamic> toJson() {
    return {
      codeKey: code,
    };
  }
}

class FavoriteGroupsQuestionsParams {
  final int lessonId;
  final int? typeId;

  FavoriteGroupsQuestionsParams({
    required this.lessonId,
    required this.typeId,
  });
}

class IncorrectAnswerGroupsQuestionsParams {
  final int lessonId;
  final int? typeId;

  IncorrectAnswerGroupsQuestionsParams({
    required this.lessonId,
    required this.typeId,
  });
}

class EditedQuestionsByLessonParams {
  final int lessonId;
  final int? typeId;

  EditedQuestionsByLessonParams({
    required this.lessonId,
    this.typeId,
  });
}

class ToggleQuestionFavoriteParams {
  final int questionId;
  final bool isFavorite;

  ToggleQuestionFavoriteParams({
    required this.questionId,
    required this.isFavorite,
  });
}

class ToggleQuestionIncorrectAnswerParams {
  final int questionId;
  final bool answerStatus;

  ToggleQuestionIncorrectAnswerParams({
    required this.questionId,
    required this.answerStatus,
  });
}

class SaveQuestionNoteParams {
  final int questionId;
  final String note;

  SaveQuestionNoteParams({
    required this.questionId,
    required this.note,
  });
}

class GetQuestionNoteParams {
  final int questionId;

  GetQuestionNoteParams({
    required this.questionId,
  });
}

class LessonsWithFavoriteGroupsParams {
  final int subjectId;

  LessonsWithFavoriteGroupsParams({
    required this.subjectId,
  });
}

class LessonsWithIncorrectAnswerGroupsParams {
  final int subjectId;

  LessonsWithIncorrectAnswerGroupsParams({
    required this.subjectId,
  });
}

class LessonsWithEditedQuestionsParams {
  final int subjectId;

  LessonsWithEditedQuestionsParams({
    required this.subjectId,
  });
}

class CheckSubjectSyncParams {
  final int subjectId;

  CheckSubjectSyncParams({
    required this.subjectId,
  });
}

class QuestionPhotoParams {
  final String questionUrl;
  final int questionId;

  QuestionPhotoParams({
    required this.questionUrl,
    required this.questionId,
  });
}

class QuizFilterParams {
  final int subjectId;
  final List<int> lessonIds;
  final List<int> typeIds;
  final List<int> tagIds;

  QuizFilterParams({
    required this.subjectId,
    required this.lessonIds,
    required this.typeIds,
    required this.tagIds,
  });
}

//getAvailableTypes params
class GetAvailableTypesParams {
  final int subjectId;
  final List<int> selectedLessonIds;
  final List<int> selectedTagIds;

  GetAvailableTypesParams({
    required this.subjectId,
    required this.selectedLessonIds,
    required this.selectedTagIds,
  });
}

class GetAvailableTagsParams {
  final int subjectId;
  final List<int> selectedLessonIds;
  final List<int> selectedTypeIds;

  GetAvailableTagsParams({
    required this.subjectId,
    required this.selectedLessonIds,
    required this.selectedTypeIds,
  });
}

class GetAvailableLessonsParams {
  final int subjectId;
  final List<int> selectedTypeIds;
  final List<int> selectedTagIds;

  GetAvailableLessonsParams({
    required this.subjectId,
    required this.selectedTypeIds,
    required this.selectedTagIds,
  });
}
