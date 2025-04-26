import 'package:flutter/material.dart';
import 'package:sanad_school/core/theme/theme.dart';

import '../../../../core/utils/services/service_locator.dart';
import '../../../../main.dart';
import '../../../questions/presentation/questions_screen.dart';
import 'subject_card.dart';

class SubjectsGrid extends StatelessWidget {
  const SubjectsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return const SubjectsLayout();
  }
}

class SubjectsLayout extends StatefulWidget {
  const SubjectsLayout({super.key});

  @override
  State<SubjectsLayout> createState() => _SubjectsLayoutState();
}

class _SubjectsLayoutState extends State<SubjectsLayout> {
  //0xFF4CAF50
  //0xFF1A1B1F

  int? expandedIndex;

  late List<bool> isExpanded = [];
  @override
  void initState() {
    super.initState();
    isExpanded = List.filled(9, false);
  }

  @override
  Widget build(BuildContext context) {
    final subjects = [
      //0xFFDB8E44
      //0xFFB06F36
      Subject(
        title: 'علوم',
        icon: Icons.science,
        description: 'اكتشف عالم العلوم الطبيعية والظواهر العلمية من خلال دروس تفاعلية وتجارب عملية',
        color: getIt<AppTheme>().extendedColors.gradientGreen,
        questions: sampleQuestions,
      ),
      Subject(
        title: 'فرنسي',
        icon: Icons.abc,
        description: 'تعلم اللغة الفرنسية من خلال محتوى تعليمي متميز وتدريبات لغوية متنوعة',
        color: getIt<AppTheme>().extendedColors.gradientBlue,
        questions: sampleQuestions,
      ),
      Subject(
        title: 'انجليزي',
        icon: Icons.abc,
        description: 'أتقن اللغة الإنجليزية مع دروس شاملة تغطي القواعد والمحادثة والكتابة',
        color: getIt<AppTheme>().extendedColors.gradientPurple,
        questions: sampleQuestions,
      ),
      Subject(
        title: 'رياضيات',
        icon: Icons.calculate,
        description: 'استكشف عالم الرياضيات مع شرح مبسط للمفاهيم وتمارين تطبيقية',
        color: getIt<AppTheme>().extendedColors.gradientPink,
        questions: sampleQuestions,
      ),
      Subject(
        title: 'فيزياء',
        icon: Icons.bolt,
        description: 'تعرف على قوانين الفيزياء وتطبيقاتها في الحياة اليومية',
        color: getIt<AppTheme>().extendedColors.gradientIndigo,
        questions: sampleQuestions,
      ),
      Subject(
        title: 'كيمياء',
        icon: Icons.biotech,
        description: 'ادرس التفاعلات الكيميائية والعناصر مع تجارب افتراضية تفاعلية',
        color: getIt<AppTheme>().extendedColors.gradientOrange,
        questions: sampleQuestions,
      ),
      Subject(
        title: 'ديانة',
        icon: Icons.menu_book,
        description: 'تعمق في دراسة العلوم الدينية والأخلاق والقيم الإسلامية',
        color: getIt<AppTheme>().extendedColors.gradientBrown,
        questions: sampleQuestions,
      ),
      Subject(
        title: 'وطنية',
        icon: Icons.flag,
        description: 'تعرف على تاريخ وطنك وقيمه ومؤسساته الوطنية',
        color: getIt<AppTheme>().extendedColors.gradientBlueGrey,
        questions: sampleQuestions,
      ),
      Subject(
        title: 'عربي',
        icon: Icons.language,
        description: 'أتقن اللغة العربية من خلال دروس في النحو والأدب والبلاغة',
        color: getIt<AppTheme>().extendedColors.gradientTeal,
        questions: sampleQuestions,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        // final int rowCount = (subjects.length / 2).ceil();
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            return _card(index, subjects);
          },
        );
      },
    );
  }

  Widget _card(int index, List<Subject> subjects) {
    return Column(
      children: [
        SubjectCard(
          subject: subjects[index],
          isExpanded: isExpanded[index],
          isShrunk: ((index < isExpanded.length && isExpanded[index])), // index+1
          onLongPress: () {
            setState(() {
              isExpanded[index] = !isExpanded[index];
            });
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
