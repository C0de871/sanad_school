import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/quiz_selection_cubit.dart';
import '../../../cubits/quiz_selection_stata.dart';

class QuestionCountSelector extends StatelessWidget {
  const QuestionCountSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizSelectionCubit, QuizSelectionState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "العدد المطلوب",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 40,
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              controller: context.read<QuizSelectionCubit>().countController,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              onChanged: (value) {
                                context.read<QuizSelectionCubit>().updateRequestedQuestionCount(int.parse(value));
                              },
                              decoration: InputDecoration(
                                isCollapsed: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 5), // Adjust height
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "سؤال",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      inactiveTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      thumbColor: Theme.of(context).colorScheme.primary,
                      overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                    ),
                    child: Slider(
                      min: 0,
                      max: max(0, state.availableQuestionCount.toDouble()),
                      // max: 2,
                      divisions: max(1, state.availableQuestionCount),
                      value: state.requestedQuestionCount.toDouble(),
                      onChanged: (value) {
                        context.read<QuizSelectionCubit>().updateRequestedQuestionCount(value.toInt());
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("0"),
                      Text(state.availableQuestionCount.toString()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
