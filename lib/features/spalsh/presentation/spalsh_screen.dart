import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../core/Routes/app_routes.dart';
// import 'package:your_app/home_screen.dart'; // استبدلها بشاشتك الرئيسية

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // تحميل الفيديو
    _controller = VideoPlayerController.asset("assets/videos/sanad_intro.mp4")
      ..initialize().then((_) {
        setState(() {});
        _controller.play(); // تشغيل الفيديو تلقائيًا
      });

    // الانتقال إلى الشاشة الرئيسية بعد ثانيتين
    Future.delayed(Duration(seconds: 4), () {
      if (context.mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.login,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // لون الخلفية في حال لم يتم تحميل الفيديو بسرعة
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(), // إظهار مؤشر تحميل أثناء التهيئة
      ),
    );
  }
}
