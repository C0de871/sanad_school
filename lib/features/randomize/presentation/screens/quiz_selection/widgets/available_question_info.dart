import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/theme/theme.dart';
import '../../../../../../core/utils/services/service_locator.dart';
import '../../../cubits/quiz_selection_cubit.dart';
import '../../../cubits/quiz_selection_stata.dart';

class AvailableQuestionsInfo extends StatelessWidget {
  const AvailableQuestionsInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizSelectionCubit, QuizSelectionState>(
      builder: (context, state) {
        final bool isValid = (state.availableQuestionCount >= state.requestedQuestionCount && state.availableQuestionCount != 0 && state.requestedQuestionCount != 0);

        final backgroundColor = isValid ? getIt<AppTheme>().extendedColors.gradientGreen.withOpacity(0.2) : getIt<AppTheme>().extendedColors.gradientPink.withOpacity(0.2);

        final textColor = isValid ? getIt<AppTheme>().extendedColors.gradientGreen : getIt<AppTheme>().extendedColors.gradientPink;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                "عدد الأسئلة المتاحة",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${state.availableQuestionCount} سؤال",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              if (!isValid)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "الرجاء تقليل عدد الأسئلة المطلوبة أو اختيار المزيد من الدروس واختيار سؤال واحد أو أكتر",
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
