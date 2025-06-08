// import 'package:flutter/material.dart';


import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({super.key});

  @override
  Widget build(BuildContext context) {
    //todo remove this gesture dectecotr
    final colors =Theme.of(context).colorScheme ;
    return GestureDetector(
      onTap: () async {
        // final dir = await getApplicationDocumentsDirectory();
        // final path = '${dir.path}/debug_log.txt';
        // final params = ShareParams(
        //   text: 'Great picture',
        //   files: [XFile(path)],
        // );

        // final result = await SharePlus.instance.share(params);

        // if (result.status == ShareResultStatus.success) {
        //   log('Thank you for sharing the picture!');
        // }
      },
      child: Image.asset(
        "assets/icons/sanad_altaleb_white.png",
        height: 40,
        width: 40,
        color:colors.onPrimaryContainer ,
      ),
    );
  }
}
