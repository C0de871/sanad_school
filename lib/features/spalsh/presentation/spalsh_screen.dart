
import 'package:awesome_video_player/awesome_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/Routes/app_routes.dart';
import '../../../core/helper/app_functions.dart';
import '../../../core/shared/widgets/animated_loading_screen.dart';
import '../../auth/presentation/cubit/auth_cubit/auth_cubit.dart';

class SamsungSplashScreen extends StatefulWidget {
  const SamsungSplashScreen({super.key});

  @override
  State<SamsungSplashScreen> createState() => _SamsungSplashScreenState();
}

class _SamsungSplashScreenState extends State<SamsungSplashScreen> {
  BetterPlayerController? _betterPlayerController;
  bool _isVideoComplete = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await Utils.saveAssetVideoToFile("assets/videos/sanad_intro.mp4", "sanad_intro.mp4");
    final videoUrl = await Utils.getFileUrl("sanad_intro.mp4");
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.file, videoUrl);
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        looping: false,
        // aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: false,
          backgroundColor: Colors.white,
        ),
        fit: BoxFit.contain,
        aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
        // expandToFill: false,
        // autoDetectFullscreenAspectRatio: true,
        // autoDetectFullscreenDeviceOrientation: true,
        // deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
      ),
      betterPlayerDataSource: betterPlayerDataSource,
    );

    _betterPlayerController!.addEventsListener((BetterPlayerEvent event) async {
      if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
        // await Future.delayed(const Duration(seconds: 3));
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
        setState(() {
          _isVideoComplete = true;
        });
        _navigateBasedOnAuthState();
      }
    });

    setState(() {
      _isLoading = false;
    });
  }

  void _navigateBasedOnAuthState() async {
    if (!context.mounted) return;

    final authState = context.read<AuthCubit>().state;
    // await Future.delayed(const Duration(seconds: 3));
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
    if (authState is PreviouslyAuthentecated) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else if (authState is UnAuthentecated) {
      Navigator.pushNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
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
        body: _isLoading
            ? const CoolLoadingScreen()
            : SizedBox(
                width: double.infinity,
                child: BetterPlayer(
                  controller: _betterPlayerController!,
                ),
              ),
      ),
    );
  }
}

class NonSamsungSplashScreen extends StatefulWidget {
  const NonSamsungSplashScreen({super.key});

  @override
  State<NonSamsungSplashScreen> createState() => _NonSamsungSplashScreenState();
}

class _NonSamsungSplashScreenState extends State<NonSamsungSplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is PreviouslyAuthentecated) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state is UnAuthentecated) {
            Navigator.pushNamed(context, AppRoutes.login);
          }
        },
        child: Center(
          child: Image.asset(
            'assets/app_icon/sanad_icon.png',
            width: MediaQuery.of(context).size.width * 0.5,
          ),
        ),
      ),
    );
  }
}
