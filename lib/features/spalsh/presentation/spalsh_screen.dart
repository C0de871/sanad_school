import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../../core/Routes/app_routes.dart';
import '../../auth/presentation/cubit/auth_cubit/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _isVideoComplete = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset("assets/videos/sanad_intro.mp4")
      ..initialize().then((_) {
        setState(() {});
        _controller.play();

        // Listen for video completion
        _controller.addListener(() {
          if (_controller.value.position >= _controller.value.duration) {
            setState(() {
              _isVideoComplete = true;
            });
            _navigateBasedOnAuthState();
          }
        });
      });
  }

  void _navigateBasedOnAuthState() {
    if (!context.mounted) return;

    final authState = context.read<AuthCubit>().state;
    if (authState is PreviouslyAuthentecated) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else if (authState is UnAuthentecated) {
      Navigator.pushNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (_isVideoComplete) {
          _navigateBasedOnAuthState();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
