// AllTagsScreen.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_school/core/Routes/app_routes.dart';
import 'package:sanad_school/features/tags/presentation/cubits/tag_cubit.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../core/utils/services/service_locator.dart';
import '../../../auth/presentation/widgets/animated_raised_button.dart';

class AllTagsTab extends StatelessWidget {
  const AllTagsTab({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("جميع التصنيفات"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: BlocBuilder<TagCubit, TagState>(
          builder: (context, state) {
            log("");
            switch (state) {
              case TagLoading():
                return const Center(child: CircularProgressIndicator());
              case TagError():
                return Center(child: Text(state.message));
              case TagLoaded():
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
