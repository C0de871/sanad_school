import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:../video_player/video_download_service.dart';
import 'dart:io';

/// Stateful widget to fetch and then display video content.
class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String videoId;
  final String className;
  final String subjectName;
  final String teacherName;
  final String unit;
  final bool isDownloaded;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.videoId,
    required this.className,
    required this.subjectName,
    required this.teacherName,
    required this.unit,
    this.isDownloaded = false,
  });

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _showControls = true;
  double _currentPosition = 0;
  double _totalDuration = 0;
  double _playbackSpeed = 1.0;
  bool _isFullScreen = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isDownloaded = false;
  final List<double> _playbackSpeeds = [
    0.25,
    0.5,
    0.75,
    1.0,
    1.25,
    1.5,
    1.75,
    2.0,
  ];

  @override
  void initState() {
    super.initState();
    _isDownloaded = widget.isDownloaded;
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      if (_isDownloaded) {
        log('Downloaded video');
        final videoPath = await VideoDownloadService().getVideoPath(
          videoId: widget.videoId,
          className: widget.className,
          subjectName: widget.subjectName,
          teacherName: widget.teacherName,
          unit: widget.unit,
        );
        final file = File(videoPath);
        if (!await file.exists()) {
          log('Local file not found, trying to play online version');
          // If local file doesn't exist but we have a URL, try to play online version
          if (widget.videoUrl.isNotEmpty) {
            _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
            await _controller!.initialize();
            setState(() {
              _totalDuration = _controller!.value.duration.inMilliseconds.toDouble();
              _isDownloaded = false;
              _hasError = false;
            });
          } else {
            setState(() {
              _hasError = true;
              _errorMessage = 'Video file not found. Please download again.';
            });
            return;
          }
        } else {
          _controller = VideoPlayerController.file(File(videoPath));
          await _controller!.initialize();
          setState(() {
            _totalDuration = _controller!.value.duration.inMilliseconds.toDouble();
            _hasError = false;
          });
        }
      } else {
        _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
        await _controller!.initialize();
        setState(() {
          _totalDuration = _controller!.value.duration.inMilliseconds.toDouble();
          _hasError = false;
        });
      }

      _controller?.addListener(() {
        if (mounted) {
          setState(() {
            _currentPosition = _controller!.value.position.inMilliseconds.toDouble();
          });
        }
      });
    } catch (e) {
      print('Video initialization error: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'خطأ في الاتصال بالانترنت: لا يوجد شبكة، تحقق من جودة الاتصال بالانترنت ثم أعد المحاولة';
        });
      }
    }
  }

  Future<void> _downloadVideo() async {
    try {
      await VideoDownloadService().downloadVideo(
        videoUrl: widget.videoUrl,
        videoId: widget.videoId,
        className: widget.className,
        subjectName: widget.subjectName,
        teacherName: widget.teacherName,
        unit: widget.unit,
      );
      setState(() => _isDownloaded = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download video: $e')),
      );
    }
  }

  void _retryVideo() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });
    _controller?.dispose();
    _initializeVideo();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _changePlaybackSpeed(BuildContext context, Offset position) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + size.width,
        position.dy + size.height,
      ),
      items:
          _playbackSpeeds.map((speed) {
            return PopupMenuItem(
              value: speed,
              height: 36,
              child: Opacity(
                opacity: 0.75,
                child: Text(
                  '${speed}x',
                  style: TextStyle(
                    color: _playbackSpeed == speed ? Colors.blue : Colors.white,
                    fontWeight:
                        _playbackSpeed == speed
                            ? FontWeight.bold
                            : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
      color: Colors.black87,
      elevation: 8,
      constraints: BoxConstraints(
        maxHeight: 200,
      ),
    ).then((value) {
      if (value != null) {
        setState(() {
          _playbackSpeed = value;
          _controller?.setPlaybackSpeed(_playbackSpeed);
        });
      }
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, color: Colors.white, size: 48),
                const SizedBox(height: 16),
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _retryVideo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(
                    'حاول مجدداً',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: CircularProgressIndicator(color: Colors.blue),
          ),
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _toggleControls,
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: _isFullScreen
                      ? MediaQuery.of(context).size.width /
                          MediaQuery.of(context).size.height
                      : _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              ),
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: IgnorePointer(
                  ignoring: !_showControls,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              color: Colors.black26,
                              margin: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom + 8.0,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          _formatDuration(Duration(milliseconds: _currentPosition.toInt())),
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        Expanded(
                                          child: Slider(
                                            value: _currentPosition,
                                            min: 0.0,
                                            max: _totalDuration,
                                            activeColor: Colors.blue,
                                            onChanged: (value) {
                                              setState(() {
                                                _currentPosition = value;
                                              });
                                              _controller?.seekTo(Duration(milliseconds: value.toInt()));
                                            },
                                          ),
                                        ),
                                        Text(
                                          _formatDuration(Duration(milliseconds: _totalDuration.toInt())),
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.replay_10, color: Colors.white),
                                          onPressed: () {
                                            final newPosition = _controller!.value.position - const Duration(seconds: 10);
                                            _controller?.seekTo(newPosition);
                                          },
                                        ),
                                        IconButton(
                                          iconSize: 48,
                                          icon: Icon(
                                            _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (_controller!.value.isPlaying) {
                                                _controller?.pause();
                                              } else {
                                                _controller?.play();
                                              }
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.forward_10, color: Colors.white),
                                          onPressed: () {
                                            final newPosition = _controller!.value.position + const Duration(seconds: 10);
                                            _controller?.seekTo(newPosition);
                                          },
                                        ),
                                        Builder(
                                          builder: (context) => TextButton(
                                            onPressed: () {
                                              final RenderBox box = context.findRenderObject() as RenderBox;
                                              final Offset position = box.localToGlobal(Offset.zero);
                                              _changePlaybackSpeed(context, position);
                                            },
                                            child: Text(
                                              '${_playbackSpeed}x',
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                                            color: Colors.white,
                                          ),
                                          onPressed: _toggleFullScreen,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (!_isDownloaded)
                          Positioned(
                            top: 16,
                            right: 16,
                            child: IconButton(
                              icon: const Icon(Icons.download, color: Colors.white),
                              onPressed: _downloadVideo,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _controller?.dispose();
    super.dispose();
  }
}
