import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_school/core/theme/theme.dart';
import 'package:sanad_school/features/subjects/presentation/cubit/subject_cubit.dart';

import '../../../../core/shared/widgets/animated_loading_screen.dart';
import '../../../../core/utils/services/service_locator.dart';
import '../../domain/entities/subject_entity.dart';
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

  final List<Color> subjectColors = [
    // Color(0xFF4CAF50), // Green
    // Color(0xFF2196F3), // Blue
    // Color(0xFFFF9800), // Orange
    // Color(0xFFE91E63), // Pink
    // Color(0xFF9C27B0), // Purple
    // Color(0xFF00BCD4), // Cyan
    // Color(0xFF795548), // Brown
    // Color(0xFF607D8B), // Blue Grey
    getIt<AppTheme>().extendedColors.gradientGreen,
    getIt<AppTheme>().extendedColors.gradientBlue,
    getIt<AppTheme>().extendedColors.gradientOrange,
    getIt<AppTheme>().extendedColors.gradientPink,
    getIt<AppTheme>().extendedColors.gradientPurple,
    getIt<AppTheme>().extendedColors.gradientBrown,
    getIt<AppTheme>().extendedColors.gradientIndigo,
    getIt<AppTheme>().extendedColors.gradientTeal,
    getIt<AppTheme>().extendedColors.gradientBlueGrey,
  ];
  @override
  void initState() {
    super.initState();
    log(subjectColors.toString());
    // isExpanded = List.filled(9, false);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // final int rowCount = (subjects.length / 2).ceil();
        return BlocBuilder<SubjectCubit, SubjectState>(
          builder: (context, state) {
            if (state is SubjectSuccess) {
              log("state: ${state.subjects.length}");
              log("subjects: ${state.subjects}");
            }
            return switch (state) {
              SubjectInitial() => SizedBox(),
              SubjectLoading() => Center(
                  child: CoolLoadingScreen(),
                ),
              SubjectSuccess() => RefreshIndicator(
                  onRefresh: () async {
                    await context
                        .read<SubjectCubit>()
                        .getSubjects(isRefresh: true);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.subjects.length,
                    itemBuilder: (context, index) {
                      return _card(index, state);
                    },
                  ),
                ),
              SubjectFailure() => Center(
                  child: Text(state.message),
                ),
            };
          },
        );
      },
    );
  }

  Widget _card(int index, SubjectSuccess state) {
    return Column(
      children: [
        SubjectCard(
          subject: state.subjects[index],
          isExpanded: state.isExpanded[index],
          isShrunk: ((index < state.isExpanded.length &&
              state.isExpanded[index])), // index+1
          color: subjectColors[index % subjectColors.length],
          onLongPress: () {
            setState(() {
              state.isExpanded[index] = !state.isExpanded[index];
            });
          },
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
