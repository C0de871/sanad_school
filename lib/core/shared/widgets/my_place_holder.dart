import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

import '../../utils/constants/app_images.dart';
import '../../utils/constants/app_numbers.dart';

class MyPlaceHolder extends StatelessWidget {
  const MyPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("قريبا"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 200,
                  maxWidth: 300,
                ),
                child: SvgPicture.asset(
                  AppImages.underConstruction,
                ),
              ),
            ),
            const SizedBox(height: padding4 * 9),
            const Text(
              "قادم في المستقبل",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: padding4 * 3),
            const Text(
              "هذه الصفحة قيد التطوير",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                // color: AppColors.grayColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
