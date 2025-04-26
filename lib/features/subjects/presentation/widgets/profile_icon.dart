// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../../../core/Routes/app_routes.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.3),
            width: 2,
          ),
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: 14,
          backgroundColor: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.3),
          child: Icon(
            Icons.person_outline,
            size: 20,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      onPressed: () {
        //todo manar: here we will caءll the get profile api
        Navigator.pushNamed(
          context,
          AppRoutes.profile,
        );
      },
    );
  }
}
