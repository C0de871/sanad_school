import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/Routes/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/services/service_locator.dart';
import '../../../main.dart';
import '../../auth/presentation/widgets/animated_raised_button.dart';

class LessonScreen extends StatefulWidget {
  final Subject subject;
  const LessonScreen({
    super.key,
    required this.subject,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['الدروس', 'المفضلة', 'الاختبارات', 'الخاطئة', "الملفات", 'زيادة خير'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String subjectName = widget.subject.title;
    final double completePercentage = widget.subject.completePercentage;
    final String subjectDescription = widget.subject.description;
    final Color subjectColor = widget.subject.color;
    final int lessonCount = widget.subject.lessonCount;
    final colors = getIt<AppTheme>().extendedColors;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.quizSelection,
          );
        },
        label: Icon(Icons.shuffle),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: subjectColor,
          statusBarIconBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                color: subjectColor,
                child: TabBar(
                  enableFeedback: true,
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  physics: const BouncingScrollPhysics(),
                  controller: _tabController,
                  tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
                  labelColor: colors.white,
                  unselectedLabelColor: colors.white.withAlpha(150),
                  indicatorColor: colors.white,
                  dragStartBehavior: DragStartBehavior.down,
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    LessonsTab(
                      subject: widget.subject,
                      subjectName: subjectName,
                      completePercentage: completePercentage,
                      subjectDescription: subjectDescription,
                      subjectColor: subjectColor,
                      lessonCount: lessonCount,
                    ),
                    const Center(child: Text('المفضلة')),
                    const Center(child: Text('الاختبارات')),
                    const Center(child: Text('الخاطئة')),
                    const Center(child: Text('الملفات')),
                    const Center(child: Text('زيادة خير')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LessonsTab extends StatelessWidget {
  final String subjectName;
  final double completePercentage;
  final String subjectDescription;
  final Color subjectColor;
  final int lessonCount;
  final Subject subject;

  const LessonsTab({
    super.key,
    required this.subjectName,
    required this.completePercentage,
    required this.subjectDescription,
    required this.subjectColor,
    required this.lessonCount,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final colors = getIt<AppTheme>().extendedColors;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: subjectColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subjectName,
                style: TextStyle(
                  color: colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subjectDescription,
                style: TextStyle(
                  color: colors.white.withAlpha(179),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: completePercentage / 100,
                  backgroundColor: colors.white.withAlpha(77),
                  valueColor: AlwaysStoppedAnimation<Color>(colors.white),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$lessonCount دروس',
                style: TextStyle(
                  color: colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: LessonsGridView(
            subjectColor: subjectColor,
            subject: subject,
          ),
        ),
      ],
    );
  }
}

class LessonsGridView extends StatefulWidget {
  final Color subjectColor;
  final Subject subject;

  const LessonsGridView({
    super.key,
    required this.subjectColor,
    required this.subject,
  });

  @override
  State<LessonsGridView> createState() => _LessonsGridViewState();
}

class _LessonsGridViewState extends State<LessonsGridView> {
  final Map<int, bool> _expandedLessons = {};

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) => Column(
        children: [
          LessonCard(
            subject: widget.subject,
            lessonNumber: index + 1,
            isExpanded: _expandedLessons[index] ?? false,
            onTap: () => _toggleLesson(index),
            subjectColor: widget.subjectColor,
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
      itemCount: 8,
    );
  }

  void _toggleLesson(int index) {
    setState(() {
      _expandedLessons[index] = !(_expandedLessons[index] ?? false);
    });
  }
}

class LessonCard extends StatefulWidget {
  final int lessonNumber;
  final bool isExpanded;
  final VoidCallback onTap;
  final Color subjectColor;
  final Subject subject;

  const LessonCard({
    super.key,
    required this.lessonNumber,
    required this.isExpanded,
    required this.onTap,
    required this.subjectColor,
    required this.subject,
  });

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> with TickerProviderStateMixin {
  // late AnimationController _controller;
  late final List<AnimationController> controllers;
  final ScrollController _scrollController = ScrollController();
  late final List<Animation<double>> _subLessonAnimations;
  final List<String> catagories = ["لعيون سند", "صح او خطأ", "اختر الاجابة الصحيحة", 'مفردات', 'اختبارات'];

  @override
  void initState() {
    super.initState();

    controllers = List.generate(
      8,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );

    _subLessonAnimations = controllers.map((controller) {
      return CurvedAnimation(parent: controller, curve: Curves.easeOut);
    }).toList();

    if (widget.isExpanded) {
      startAnimationsIntertwined(0);
    }
  }

  void startAnimationsIntertwined(int index) {
    if (index >= controllers.length) return;

    controllers[index].forward();

    Future.delayed(const Duration(milliseconds: 60), () {
      startAnimationsIntertwined(index + 1);
    });
  }

  Future<void> startAnimationsIntertwinedReverse() async {
    List<Future<void>> futures = [];

    for (int i = controllers.length - 1; i >= 0; i--) {
      // Start reversing the animation
      Future<void> animationFuture = controllers[i].reverse();

      // Add the future to the list to track it
      futures.add(animationFuture);

      // Wait for the gap before starting the next animation
      await Future.delayed(const Duration(milliseconds: 60));
    }

    // Wait for all animations to complete before returning
    await Future.wait(futures);
  }

  @override
  void didUpdateWidget(LessonCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        startAnimationsIntertwined(0);
      } else {
        startAnimationsIntertwinedReverse();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AnimatedRaisedButtonWithChild(
      height: 160,
      backgroundColor: colors.surfaceContainerLow,
      shadowColor: getIt<AppTheme>().isDark ? Colors.blueGrey.withAlpha(70) : null,
      // shadowColor: ,
      onPressed: () async {
        if (!widget.isExpanded) {
          startAnimationsIntertwined(0);
        } else {
          await startAnimationsIntertwinedReverse();
        }
        widget.onTap();
      },
      shadowOffset: 5,
      lerpValue: 0.1,
      borderWidth: 2.5,
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.only(
        left: 8,
        bottom: 8,
        top: 8,
      ),
      child: widget.isExpanded ? _buildExpandedContent(colors) : _buildCollapsedContent(),
    );
  }

  Widget _buildCollapsedContent() {
    return Center(
      child: Text(
        'الدرس ${widget.lessonNumber}',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: widget.subjectColor,
        ),
      ),
    );
  }

  Widget _buildExpandedContent(colors) {
    return RawScrollbar(
      controller: _scrollController,
      scrollbarOrientation: ScrollbarOrientation.right,
      thumbVisibility: true,
      thickness: 3,
      radius: Radius.circular(8),
      timeToFade: Duration(seconds: 2),
      mainAxisMargin: 6,
      fadeDuration: Duration(milliseconds: 300),
      crossAxisMargin: 2.5,
      child: GridView.builder(
        controller: _scrollController,
        cacheExtent: 0,
        padding: EdgeInsets.only(
          right: 8,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.3,
        ),
        itemBuilder: (context, index) {
          return ScaleTransition(
            scale: _subLessonAnimations[index],
            child: AnimatedRaisedButtonWithChild(
              backgroundColor: colors.surfaceContainerLow,
              shadowColor: getIt<AppTheme>().isDark ? Colors.blueGrey.withAlpha(70) : null,
              shadowOffset: 3,
              lerpValue: 0.1,
              borderWidth: 1.5,
              borderRadius: BorderRadius.circular(16),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  arguments: widget.subject,
                  AppRoutes.questions,
                );
              },
              child: Center(
                child: Text(
                  catagories[index % 5],
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.subjectColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
        itemCount: 8,
      ),
    );
  }
}
