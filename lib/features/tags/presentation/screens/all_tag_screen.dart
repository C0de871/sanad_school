// ignore_for_file: public_member_api_docs, sort_constructors_first
// AllTagsScreen.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sanad_school/core/Routes/app_routes.dart';
import 'package:sanad_school/features/tags/presentation/cubits/tag_cubit.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../core/utils/services/service_locator.dart';
import '../../../../core/shared/widgets/animated_empty_screen.dart';
import '../../../../core/shared/widgets/animated_loading_screen.dart';
import '../../../auth/presentation/widgets/animated_raised_button.dart';

class AllTagsTab extends StatelessWidget {
  const AllTagsTab({
    super.key,
    required this.color,
    required this.direction,
  });
  final Color color;
  final TextDirection direction;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BlocBuilder<TagCubit, TagState>(
          builder: (context, state) {
            log("");
            switch (state) {
              case TagLoading():
                return const Center(child: CoolLoadingScreen());
              case TagError():
                return Center(child: Text(state.message));
              case TagLoaded():
                if (state.tags.isEmpty) {
                  return EmptyStateScreen(
                    iconColor: color.withOpacity(0.5),
                    textColor: color.withOpacity(0.5),
                    icon: Icons.inbox_rounded,
                    title: "الدورات والتصنيفات فارغة",
                    message: "لا يوجد دورات أو تصنيفات لهده المادة",
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: state.tags.length,
                  itemBuilder: (context, index) {
                    final tag = state.tags[index];

                    return AnimatedRaisedButtonWithChild(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.questionsFromTag, arguments: {
                        'color': color,
                        'tag': tag,
                        'direction': direction,
                      }),
                      // backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceVariant,
                      // shadowColor: isSelected ? (getIt<AppTheme>().extendedColors.buttonShadow) : (getIt<AppTheme>().isDark ? Colors.blueGrey.withAlpha(70) : null),
                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                      shadowColor: (getIt<AppTheme>().isDark ? Colors.blueGrey.withAlpha(70) : null),

                      shadowOffset: 5,
                      lerpValue: 0.1,
                      borderWidth: 1.5,
                      borderRadius: BorderRadius.circular(16),
                      child: Center(
                        child: Text(
                          tag.name,
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
              case TagInitial():
                return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
