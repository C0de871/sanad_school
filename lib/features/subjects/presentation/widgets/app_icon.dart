// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../../../core/Routes/app_routes.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({super.key});

  @override
  Widget build(BuildContext context) {
    //todo remove this gesture dectecotr
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.test1,
        arguments: 2,
      ),
      child: Image.asset(
        "assets/app_icon/sanad_icon.png",
        height: 40,
        width: 40,
      ),
    );
  }
}
