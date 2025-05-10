import 'dart:math';

import 'package:flutter/material.dart';
import '../../../core/shared/widgets/animated_loading_screen.dart';
import '../courses/courses_screen.dart';
import '../../../core/utils/services/video_download_service.dart';
import '../video_player/video_player_screen.dart';

class CourseDetailsScreen extends StatefulWidget {
  final int courseId;
  final String courseTitle;
  const CourseDetailsScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class Course {
  final int id;
  final String title;
  bool isRegistered = false;

  Course({required this.id, required this.title, required this.isRegistered});
}

class Unit {
  final int id;
  final String title;
  final List<Lesson> lessons;

  Unit({required this.id, required this.title, required this.lessons});
}

class Lesson {
  final int id;
  final String title;
  final String duration;
  final List<Video> videos;

  Lesson({
    required this.id,
    required this.title,
    required this.duration,
    required this.videos,
  });
}

class Video {
  final int id;
  final String title;
  final String duration;
  final String tempUrl;
  bool isDownloaded;

  Video({
    required this.id,
    required this.title,
    required this.duration,
    required this.tempUrl,
    required this.isDownloaded,
  });
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  List<Unit> units = [];
  int selectedIndex = 0;
  bool isLoading = true;
  Course? course = Course(
    id: 0,
    title: 'اسم الأستاذ / الكورس',
    isRegistered: false,
  );
  final _downloadService = VideoDownloadService();

  @override
  void initState() {
    super.initState();
    fetchUnits();
  }

  Future<void> fetchUnits() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Create course
    course = Course(
      id: widget.courseId,
      title: widget.courseTitle,
      isRegistered: false,
    );

    // Replace with actual API response
    final response = List.generate(
      5,
      (index) => {
        'id': index + 1,
        'name': 'الوحدة ${index + 1}',
        'lessons': List.generate(
          index + 1,
          (lessonIndex) => {
            'id': lessonIndex,
            'name': 'الدرس ${lessonIndex + 1}',
            'videos': List.generate(
              lessonIndex + 1,
              (videoIndex) => {
                'id': videoIndex + 1,
                'name': 'الفيديو ${videoIndex + 1}',
                'isLocked': !course!.isRegistered,
                'period': '${DateTime.now().minute}:${DateTime.now().second}',
                "url": "https://file-examples.com/storage/fe07feb1a26815fd492794e/2017/04/file_example_MP4_640_3MG.mp4",
              },
            ),
          },
        ),
      },
    );

    // Convert response to Unit objects
    List<Unit> convertedUnits = [];
    for (var unitData in response) {
      List<Lesson> lessons = [];

      for (var lessonData in unitData['lessons'] as List) {
        List<Video> videos = [];

        for (var videoData in lessonData['videos'] as List) {
          bool isDownloaded = await _downloadService.isVideoDownloaded(
            videoId: videoData['id'].toString(),
            className: course!.title,
            subjectName: 'Math', // Replace with actual subject name
            teacherName: 'Teacher', // Replace with actual teacher name
            unit: unitData['name'] as String,
          );

          videos.add(
            Video(
              id: videoData['id'],
              title: videoData['name'],
              duration: '${DateTime.now().minute}:${DateTime.now().second}',
              tempUrl: videoData['url'],
              isDownloaded: isDownloaded,
            ),
          );
        }

        lessons.add(
          Lesson(
            id: lessonData['id'],
            title: lessonData['name'],
            duration: '${DateTime.now().minute}:${DateTime.now().second}',
            videos: videos,
          ),
        );
      }

      convertedUnits.add(
        Unit(
          id: unitData['id'] as int,
          title: unitData['name'] as String,
          lessons: lessons,
        ),
      );
    }

    if (mounted) {
      setState(() {
        units = convertedUnits;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: units.length,
      initialIndex: 0,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: isLoading
            ? const Center(child: CoolLoadingScreen())
            : Column(
                children: [
                  _buildTabBar(scheme),
                  Expanded(
                    child: TabBarView(
                      children: units
                          .map(
                            (unit) => LessonTile(
                              unit: unit,
                              isLocked: !course!.isRegistered,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
        floatingActionButton: (course!.isRegistered)
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: MaterialButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      course = Course(
                        id: course!.id,
                        title: course!.title,
                        isRegistered: true,
                      );
                    });
                  },
                  color: scheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  minWidth: double.infinity,
                  child: Text(
                    StringsManager.register,
                    style: TextStyle(
                      color: scheme.onPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildTabBar(ColorScheme scheme) {
    return Material(
      color: Colors.transparent,
      child: TabBar(
        tabAlignment: TabAlignment.center,
        labelPadding: const EdgeInsets.symmetric(horizontal: 3),
        indicatorPadding: EdgeInsets.zero,
        splashFactory: NoSplash.splashFactory,
        isScrollable: true,
        dividerColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        tabs: List.generate(units.length, (index) => _buildTab(index, scheme)),
      ),
    );
  }

  Widget _buildTab(int index, ColorScheme scheme) {
    final unit = units[index];
    final isSelected = selectedIndex == index;

    return AnimatedContainer(
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 400),
      padding: EdgeInsets.only(
        top: isSelected ? 0 : 20,
        bottom: isSelected ? 5 : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        color: isSelected ? scheme.secondary : scheme.primaryContainer,
      ),
      width: 80,
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(0, isSelected ? 0 : -20, 0),
      height: 80,
      child: Text(
        unit.title,
        style: TextStyle(
          color: isSelected ? scheme.onSecondary : scheme.onPrimaryContainer,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  AppBar _buildAppBar() {
    final scheme = Theme.of(context).colorScheme;
    return AppBar(
      title: Text(
        course?.title ?? "اسم الأستاذ / الكورس",
        style: TextStyle(color: scheme.onPrimary),
      ),
      centerTitle: true,
      backgroundColor: scheme.primary,
      leading: BackButton(color: scheme.onPrimary),
      actions: [Icon(Icons.menu_book, color: scheme.onPrimary)],
    );
  }
}

// #########################################################################
// !LESSON TILE

class LessonTile extends StatefulWidget {
  final Unit unit;
  final bool isLocked;
  const LessonTile({super.key, required this.unit, required this.isLocked});

  @override
  State<LessonTile> createState() => _LessonTileState();
}

class _LessonTileState extends State<LessonTile> {
  // Optimized theme with only necessary properties
  static final _expansionTileTheme = ThemeData(
    splashColor: Colors.transparent,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x00415e91)),
    hoverColor: Colors.transparent,
    highlightColor: Colors.transparent,
    dividerColor: Colors.transparent,
    expansionTileTheme: const ExpansionTileThemeData(
      backgroundColor: Colors.transparent,
      collapsedBackgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
    ),
  );

  // Reusable shape to avoid recreating the same object multiple times
  static final _tileShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
  );

  // Reusable animation style
  static final _expansionAnimation = AnimationStyle(
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  );

  @override
  Widget build(BuildContext context) {
    final lessons = widget.unit.lessons;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Theme(
        data: _expansionTileTheme,
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Column(
            children: [
              for (int i = 0; i < lessons.length; i++) _buildLessonTile(lessons[i]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonTile(Lesson lesson) {
    return ExpansionTile(
      showTrailingIcon: false,
      maintainState: true,
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      clipBehavior: Clip.none,
      onExpansionChanged: (_) => setState(() {}),
      shape: _tileShape,
      collapsedShape: _tileShape,
      expansionAnimationStyle: _expansionAnimation,
      title: LessonTitle(lesson: lesson),
      children: [
        LessonDetails(
          videos: lesson.videos,
          isLocked: widget.isLocked,
          className: 'nine',
          subjectName: 'Math', // Replace with actual subject name
          teacherName: 'Teacher', // Replace with actual teacher name
          unit: widget.unit.title,
        ),
      ],
    );
  }
}
// #########################################################################
// !LESSON Title

class LessonTitle extends StatelessWidget {
  final Lesson lesson;
  const LessonTitle({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = ExpansionTileController.of(context);

    final textStyle = TextStyle(
      color: scheme.onPrimaryContainer,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(24),
      topRight: const Radius.circular(24),
      bottomLeft: controller.isExpanded ? Radius.zero : const Radius.circular(24),
      bottomRight: controller.isExpanded ? Radius.zero : const Radius.circular(24),
    );
    final staticBorderRadius = BorderRadius.circular(24);

    final staticBorder = BorderDirectional(
      start: BorderSide(color: scheme.primary),
      end: BorderSide(color: scheme.primary),
      top: BorderSide(color: scheme.primary),
      bottom: BorderSide(color: scheme.primary),
    );
    final border = BorderDirectional(
      start: BorderSide(color: scheme.primary),
      end: BorderSide(color: scheme.primary),
    );

    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          transform: Matrix4.translationValues(
            0,
            controller.isExpanded ? 8 : 0,
            0,
          ),
          constraints: const BoxConstraints(minHeight: 80),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Colors.transparent,
            border: border,
          ),
        ),
        Container(
          // duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          constraints: const BoxConstraints(minHeight: 80),
          decoration: BoxDecoration(
            borderRadius: staticBorderRadius,
            color: scheme.primaryContainer,
            border: staticBorder,
            boxShadow: [
              BoxShadow(
                color: scheme.primary,
                blurRadius: 3,
                blurStyle: BlurStyle.normal,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Text(
                      lesson.duration,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: textStyle,
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Text(
                      lesson.title,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: textStyle,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '${lesson.id + 1}_',
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: textStyle,
                    ),
                  ),
                ],
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                transform: Matrix4.rotationZ(controller.isExpanded ? 0 : pi),
                transformAlignment: Alignment.center,
                child: Icon(
                  Icons.arrow_drop_down,
                  color: scheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
// #########################################################################
// !LESSON DETAILS

class LessonDetails extends StatefulWidget {
  final List<Video> videos;
  final bool isLocked;
  final String className;
  final String subjectName;
  final String teacherName;
  final String unit;
  const LessonDetails({
    super.key,
    required this.videos,
    required this.isLocked,
    required this.className,
    required this.subjectName,
    required this.teacherName,
    required this.unit,
  });
  @override
  State<LessonDetails> createState() => _LessonDetailsState();
}

class _LessonDetailsState extends State<LessonDetails> {
  final _downloadService = VideoDownloadService();
  Map<String, double> downloadProgress = {};
  Map<String, bool> downloadError = {};

  @override
  void initState() {
    super.initState();
    // Check for any existing download progress updates
    _refreshDownloadStatusForAllVideos();
  }

  @override
  void dispose() {
    // Ensure we don't keep any active progress updates when widget is disposed
    downloadProgress.clear();
    downloadError.clear();
    super.dispose();
  }

  Future<void> _refreshDownloadStatusForAllVideos() async {
    for (final video in widget.videos) {
      final videoId = video.id.toString();
      // Check if this video actually exists on disk
      final exists = await _checkVideoExists(videoId);
      if (exists) {
        if (mounted) {
          setState(() {
            video.isDownloaded = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            video.isDownloaded = false;
          });
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.none,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: BorderDirectional(
          start: BorderSide(color: scheme.primary),
          end: BorderSide(color: scheme.primary),
          bottom: BorderSide(color: scheme.primary),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: GestureDetector(
        onTap: () => ExpansionTileController.of(context).collapse(),
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Column(
            children: [
              ...widget.videos.map(
                (video) => _buildLessonItem(video, scheme, context, widget.isLocked),
              ),
              Icon(Icons.chevron_left, color: scheme.onPrimaryContainer),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _downloadVideo(
    String url,
    String videoId,
    BuildContext context,
  ) async {
    try {
      // Reset error state if retrying
      if (mounted) {
        setState(() {
          downloadError.remove(videoId);
          downloadProgress[videoId] = 0.01; // Start with a small value to show progress
        });
      }

      // Use VideoDownloadService to handle the download
      await _downloadService.downloadVideo(
        videoUrl: url,
        videoId: videoId,
        className: widget.className,
        subjectName: widget.subjectName,
        teacherName: widget.teacherName,
        unit: widget.unit,
        onProgressUpdate: (progress) {
          // Ensure we're still mounted before updating state
          if (!mounted) return;

          setState(() {
            if (progress <= 0) {
              // Download failed
              downloadError[videoId] = true;
              downloadProgress.remove(videoId);
              return;
            }

            // Normal progress update
            downloadProgress[videoId] = progress;

            if (progress >= 0.99) {
              // Download completed
              final index = widget.videos.indexWhere(
                (v) => v.id.toString() == videoId,
              );

              if (index != -1) {
                widget.videos[index].isDownloaded = true;
              }

              // Remove progress indicator after marking as downloaded
              downloadProgress.remove(videoId);

              // Show success message
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Video downloaded successfully'),
                  ),
                );
              }

              // Refresh status to ensure UI is consistent
              _refreshDownloadStatusForAllVideos();
            }
          });
        },
      );

      return true;
    } catch (e) {
      if (!mounted) return false;

      setState(() {
        downloadError[videoId] = true;
        downloadProgress.remove(videoId);
      });

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to download video: $e')));
      }

      return false;
    }
  }

  Future<void> _deleteVideo(String videoId) async {
    try {
      await _downloadService.deleteVideo(
        videoId: videoId,
        className: widget.className,
        subjectName: widget.subjectName,
        teacherName: widget.teacherName,
        unit: widget.unit,
      );

      if (!mounted) return;

      setState(() {
        // Find and update the video's download state
        final index = widget.videos.indexWhere(
          (v) => v.id.toString() == videoId,
        );
        if (index != -1) {
          widget.videos[index].isDownloaded = false;
        }
        downloadProgress.remove(videoId);
        downloadError.remove(videoId);

        _refreshDownloadStatusForAllVideos();
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video deleted successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete video: $e')));
      }
    }
  }

  Future<bool> _checkVideoExists(String videoId) async {
    return await _downloadService.isVideoDownloaded(
      videoId: videoId,
      className: widget.className,
      subjectName: widget.subjectName,
      teacherName: widget.teacherName,
      unit: widget.unit,
    );
  }

  Widget _buildLessonItem(
    Video video,
    ColorScheme scheme,
    BuildContext context,
    bool isLocked,
  ) {
    final textStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    final videoId = video.id.toString();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: scheme.primary),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  video.duration.split('/').last,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: textStyle,
                ),
              ),
              isLocked
                  ? Icon(
                      Icons.lock_outline_rounded,
                      color: scheme.onPrimaryContainer,
                      size: 30,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerScreen(
                                  videoUrl: video.tempUrl,
                                  videoId: videoId,
                                  className: widget.className,
                                  subjectName: widget.subjectName,
                                  teacherName: widget.teacherName,
                                  unit: widget.unit,
                                  isDownloaded: video.isDownloaded,
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.remove_red_eye_outlined,
                            color: scheme.onPrimaryContainer,
                            size: 30,
                          ),
                        ),
                        _buildDownloadActionWidget(
                          video,
                          videoId,
                          scheme,
                          context,
                        ),
                      ],
                    ),
            ],
          ),
          Flexible(
            flex: 4,
            child: Text(
              video.title,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              softWrap: true,
            ),
          ),
          Flexible(
            child: Text(
              '${video.id}.',
              style: textStyle,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadActionWidget(
    Video video,
    String videoId,
    ColorScheme scheme,
    BuildContext context,
  ) {
    // Check if video is downloaded first
    if (video.isDownloaded) {
      return IconButton(
        padding: EdgeInsets.zero,
        onPressed: () async {
          await _deleteVideo(videoId);
        },
        icon: Icon(Icons.delete_outline, color: Colors.red, size: 30),
      );
    }

    // If download is in progress, show progress indicator
    if (downloadProgress.containsKey(videoId)) {
      final progress = downloadProgress[videoId] ?? 0.0;
      return SizedBox(
        width: 30,
        height: 30,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: progress, // Use indeterminate for very small values
              color: scheme.primary,
              strokeWidth: 3,
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    // If there was an error, show retry button
    if (downloadError.containsKey(videoId) && downloadError[videoId]!) {
      return IconButton(
        padding: EdgeInsets.zero,
        onPressed: () async {
          // Clear error state before retrying
          setState(() {
            downloadError.remove(videoId);
          });

          await _downloadVideo(video.tempUrl, videoId, context);
        },
        icon: Icon(Icons.refresh, color: Colors.red, size: 30),
      );
    }

    // Otherwise show download button
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () async {
        await _downloadVideo(video.tempUrl, videoId, context);
      },
      icon: Icon(
        Icons.file_download_outlined,
        color: scheme.onPrimaryContainer,
        size: 30,
      ),
    );
  }
}
