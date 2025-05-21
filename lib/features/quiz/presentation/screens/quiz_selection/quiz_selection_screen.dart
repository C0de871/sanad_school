// Now let's create our main screen and widgets

// quiz_selection_screen.dart
import 'package:flutter/material.dart';
import 'widgets/app_header.dart';
import 'widgets/available_question_info.dart';
import 'widgets/lesson_selection.dart';
import 'widgets/question_count_selector.dart';
import 'widgets/question_types.dart';
import 'widgets/section_title.dart';
import 'widgets/start_quiz_button.dart';
import 'widgets/tag_selection.dart';

class QuizSelectionScreen extends StatelessWidget {
  const QuizSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const QuizSelectionView();
  }
}

class QuizSelectionView extends StatelessWidget {
  const QuizSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.background,
                ],
              ),
            ),
            child: Column(
              children: [
                const AppHeader(title: "اختيار الأسئلة"),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionTitle(title: "اختر الدروس"),
                          const SizedBox(height: 12),
                          const LessonsSelectionWidget(),
                          const SizedBox(height: 24),
                          const SectionTitle(title: "اختر الوسوم"),
                          const SizedBox(height: 12),
                          const TagsSelectionWidget(),
                          const SizedBox(height: 24),
                          const SectionTitle(title: "نوع الأسئلة"),
                          const SizedBox(height: 12),
                          const QuestionTypesWidget(),
                          const SizedBox(height: 24),
                          const SectionTitle(title: "عدد الأسئلة"),
                          const SizedBox(height: 12),
                          const QuestionCountSelector(),
                          const SizedBox(height: 36),
                          const AvailableQuestionsInfo(),
                          const SizedBox(height: 24),
                          const StartQuizButton(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
