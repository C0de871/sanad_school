// AllTagsScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../core/utils/services/service_locator.dart';
import '../../../../auth/presentation/widgets/animated_raised_button.dart';
import '../../cubits/quiz_selection_cubit.dart';
import '../../cubits/quiz_selection_stata.dart';

class AllTagsScreen extends StatelessWidget {
  const AllTagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuizSelectionCubit>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("جميع الوسوم"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: BlocBuilder<QuizSelectionCubit, QuizSelectionState>(
          builder: (context, state) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
              ),
              itemCount: cubit.allTags.length,
              itemBuilder: (context, index) {
                final tag = cubit.allTags[index];
                final isSelected = state.selectedTags.contains(tag);

                return AnimatedRaisedButtonWithChild(
                  onPressed: () => cubit.toggleTag(tag),
                  backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceVariant,
                  shadowColor: isSelected ? (getIt<AppTheme>().extendedColors.buttonShadow) : (getIt<AppTheme>().isDark ? Colors.blueGrey.withAlpha(70) : null),
                  shadowOffset: 5,
                  lerpValue: 0.1,
                  borderWidth: 1.5,
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
