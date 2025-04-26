// Mock implementation
import '../../questions/presentation/questions_screen.dart';


// Repository interface
abstract class QuestionRepository {
  Future<int> getAvailableQuestionsCount(
    List<String> lessons,
    List<String> tags,
    List<QuestionType> types,
  );

  Future<List<Question>> getRandomQuestions(
    List<String> lessons,
    List<String> tags,
    List<QuestionType> types,
    int count,
  );
}


class MockQuestionRepository implements QuestionRepository {
  // Simulate a database of questions
  final List<Question> _allQuestions = [
    Question(
      text: "ما هي عاصمة مصر؟",
      type: QuestionType.multipleChoice,
      answers: ["القاهرة", "الإسكندرية", "الأقصر", "أسوان"],
      correctAnswer: 0,
    ),
    // Add more mock questions
  ];

  @override
  Future<int> getAvailableQuestionsCount(
    List<String> lessons,
    List<String> tags,
    List<QuestionType> types,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // In a real app, you would filter based on the criteria
    // For demo purposes, return a number based on selections
    int baseCount = 200;
    if (lessons.isEmpty && tags.isEmpty && types.isEmpty) {
      return 0;
    }

    return baseCount - (lessons.length * 3) - tags.length;
  }

  @override
  Future<List<Question>> getRandomQuestions(
    List<String> lessons,
    List<String> tags,
    List<QuestionType> types,
    int count,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // In a real app, you would query your database
    // For demo purposes, return mock questions
    return List.generate(
        count,
        (index) => Question(
              text: "سؤال رقم ${index + 1} للاختبار",
              type: index % 2 == 0 ? QuestionType.multipleChoice : QuestionType.written,
              answers: index % 2 == 0 ? ["الخيار الأول", "الخيار الثاني", "الخيار الثالث", "الخيار الرابع"] : [],
              correctAnswer: 0,
            ));
  }
}
