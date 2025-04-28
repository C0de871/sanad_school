import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_school/features/lessons/domain/entities/lesson_entity.dart';
import 'package:sanad_school/features/lessons/presentation/cubit/lessons_cubit.dart';
import 'package:sanad_school/features/lessons/presentation/cubit/lessons_state.dart';
import 'package:sanad_school/features/tags/presentation/cubits/tag_cubit.dart';
import 'package:sanad_school/features/tags/presentation/screens/all_tag_screen.dart';
import '../../../core/Routes/app_router.dart';
import '../../../core/Routes/app_routes.dart';
import '../../../core/helper/cubit_helper.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/services/service_locator.dart';
import '../../auth/presentation/widgets/animated_raised_button.dart';
import '../../subjects/domain/entities/subject_entity.dart';

class SubjectDetailsScreen extends StatefulWidget {
  final SubjectEntity subject;
  final Color color;
  const SubjectDetailsScreen({
    super.key,
    required this.subject,
    required this.color,
  });

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // final List<String> _tabs = ['الدروس', 'المفضلة', 'الاختبارات', 'الخاطئة', "الملفات", 'زيادة خير'];
  final List<String> _tabs = ['الدروس', 'التصنيفات', 'الدورات'];
  final TagCubit examCubit = TagCubit();
  final TagCubit tagCubit = TagCubit();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    // _tabController.addListener(() {
    //   if (!_tabController.indexIsChanging) {
    //     switch (_tabController.index) {
    //       case 1:
    //         break;
    //       case 2:
    //         break;
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    _tabController.dispose();
    examCubit.close();
    tagCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String subjectName = widget.subject.name;
    final String subjectDescription = widget.subject.description;
    final Color subjectColor = widget.color;
    final colors = getIt<AppTheme>().extendedColors;

    return Scaffold(
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Navigator.pushNamed(
      //       context,
      //       AppRoutes.quizSelection,
      //     );
      //   },
      //   label: Icon(Icons.shuffle),
      // ),
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
              Container(
                width: double.infinity,
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
                        value: 20 / 100,
                        backgroundColor: colors.white.withAlpha(77),
                        valueColor: AlwaysStoppedAnimation<Color>(colors.white),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '23 دروس',
                      style: TextStyle(
                        color: colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    LessonsTab(
                      subject: widget.subject,
                      subjectColor: subjectColor,
                    ),
                    BlocProvider.value(
                      value: tagCubit
                        ..fetchTagsOrExams(
                          subjectId: widget.subject.id,
                          isExam: false,
                        ),
                      child: AllTagsTab(
                        color: subjectColor,
                      ),
                    ),
                    BlocProvider.value(
                      value: examCubit
                        ..fetchTagsOrExams(
                          subjectId: widget.subject.id,
                          isExam: true,
                        ),
                      child: AllTagsTab(
                        color: subjectColor,
                      ),
                    ),
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
  final Color subjectColor;
  final SubjectEntity subject;

  const LessonsTab({
    super.key,
    required this.subjectColor,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    // final colors = getIt<AppTheme>().extendedColors;
    return Column(
      children: [
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
  final SubjectEntity subject;

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
    return BlocBuilder<LessonsCubit, LessonsState>(
      builder: (context, state) {
        switch (state) {
          case LessonsInitial():
            return SizedBox();

          case LessonsLoading():
            return Center(
              child: CircularProgressIndicator(),
            );

          case LessonsLoaded():
            state.lessons.removeWhere((ele) => ele.questionTypes.isEmpty);
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) => Column(
                children: [
                  LessonCard(
                    lesson: state.lessons[index],
                    subject: widget.subject,
                    isExpanded: _expandedLessons[index] ?? false,
                    onTap: () => _toggleLesson(index),
                    subjectColor: widget.subjectColor,
                  ),
                  SizedBox(height: 16),
                ],
              ),
              itemCount: state.lessons.length,
            );

          case LessonsError():
            return Center(
              child: Text(state.message),
            );
        }
      },
    );
  }

  void _toggleLesson(int index) {
    setState(() {
      _expandedLessons[index] = !(_expandedLessons[index] ?? false);
    });
  }
}

class LessonCard extends StatefulWidget {
  final bool isExpanded;
  final VoidCallback onTap;
  final Color subjectColor;
  final SubjectEntity subject;
  final LessonEntity lesson;

  const LessonCard({
    super.key,
    required this.isExpanded,
    required this.onTap,
    required this.subjectColor,
    required this.subject,
    required this.lesson,
  });

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> with TickerProviderStateMixin {
  // late AnimationController _controller;
  late final List<AnimationController> controllers;
  final ScrollController _scrollController = ScrollController();
  late final List<Animation<double>> _subLessonAnimations;
  // final List<String> catagories = ["لعيون سند", "صح او خطأ", "اختر الاجابة الصحيحة", 'مفردات', 'اختبارات'];

  @override
  void initState() {
    super.initState();

    controllers = List.generate(
      widget.lesson.questionTypes.length,
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
        'الدرس ${widget.lesson.title}',
        textAlign: TextAlign.center,
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
                  arguments: {
                    "subject": widget.subject,
                    "lesson": widget.lesson.toLessonWithOneTypeEntity(index),
                    "color": widget.subjectColor,
                  },
                  AppRoutes.questions,
                );
              },
              child: Center(
                child: Text(
                  widget.lesson.questionTypes[index].name,
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
        itemCount: widget.lesson.questionTypes.length,
      ),
    );
  }
}
