import 'package:flutter/material.dart';
import 'package:sanad_school/features/subjects/presentation/widgets/app_icon.dart';
import 'package:sanad_school/features/subjects/presentation/widgets/profile_icon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const AppIcon(),
          const SizedBox(width: 16),
          _appName(context),
          const Spacer(),
          ProfileIcon(),
        ],
      ),
    );
  }

  Text _appName(BuildContext context) {
    return Text(
      'سند الطالب',
      style: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}
