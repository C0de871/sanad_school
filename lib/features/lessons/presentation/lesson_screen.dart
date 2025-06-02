import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_school/features/lessons/domain/entities/lesson_entity.dart';
import 'package:sanad_school/features/lessons/presentation/cubit/lessons_cubit.dart';
import 'package:sanad_school/features/lessons/presentation/cubit/lessons_state.dart';
import 'package:sanad_school/features/questions/data/data_sources/question_local_data_source.dart';
import 'package:sanad_school/features/subjects/presentation/cubit/subject_sync_cubit.dart';
import 'package:sanad_school/features/tags/presentation/cubits/tag_cubit.dart';
import 'package:sanad_school/features/tags/presentation/screens/all_tag_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/Routes/app_routes.dart';
import '../../../core/shared/widgets/animated_adaptive_grid_layout.dart';
import '../../../core/shared/widgets/animated_empty_screen.dart';
import '../../../core/shared/widgets/animated_loading_screen.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/services/service_locator.dart';
import '../../auth/presentation/widgets/animated_raised_button.dart';
import '../../quiz/presentation/screens/arg/screen_arg.dart';
import '../../subjects/domain/entities/subject_entity.dart';

class SubjectDetailsScreen extends StatefulWidget {
  final SubjectEntity subject;
  final Color color;
  final TextDirection textDirection;
  const SubjectDetailsScreen({
    super.key,
    required this.subject,
    required this.color,
    required this.textDirection,
  });

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // final List<String> _tabs = ['الدروس', 'المفضلة', 'الاختبارات', 'الخاطئة', "الملفات", 'زيادة خير'];
  final List<String> _tabs = [
    'الدروس',
    'الأسئلة الخاطئة',
    "الأسئلة المفضلة",
    "التصنيفات",
    "الدورات",
    "الأسئلة المعدلة"
  ];

  final TagCubit examCubit = TagCubit();
  final TagCubit tagCubit = TagCubit();

  final LessonsCubit regularLessonsCubit =
      LessonsCubit(screenType: ScreenType.regularLessons);
  final LessonsCubit editedLessonsCubit =
      LessonsCubit(screenType: ScreenType.editedLessons);
  final LessonsCubit incorrectLessonsCubit =
      LessonsCubit(screenType: ScreenType.incorrectLessons);
  final LessonsCubit favLessonsCubit =
      LessonsCubit(screenType: ScreenType.favLessons);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        regularLessonsCubit.getRegularLessons(widget.subject.id,
            isRefresh: true);
      } else if (_tabController.index == 1) {
        // incorrect
        incorrectLessonsCubit.getIncorrectLessons(widget.subject.id,
            isRefresh: true);
      } else if (_tabController.index == 2) {
        // fav
        favLessonsCubit.getFavLessons(widget.subject.id, isRefresh: true);
      } else if (_tabController.index == 3) {
        // tags
        tagCubit.fetchTagsOrExams(
            subjectId: widget.subject.id, isExam: false, isRefresh: true);
      } else if (_tabController.index == 4) {
        // exams
        examCubit.fetchTagsOrExams(
            subjectId: widget.subject.id, isExam: true, isRefresh: true);
      } else if (_tabController.index == 5) {
        // edited
        editedLessonsCubit.getEditedLessons(widget.subject.id, isRefresh: true);
      }
    });
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
    final colorScheme = Theme.of(context).colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: regularLessonsCubit,
        ),
        BlocProvider.value(
          value: editedLessonsCubit,
        ),
        BlocProvider.value(
          value: favLessonsCubit,
        ),
        BlocProvider.value(
          value: incorrectLessonsCubit,
        ),
      ],
      child: Scaffold(
        floatingActionButton: BlocBuilder<SubjectSyncCubit, SubjectSyncState>(
          builder: (context, state) {
            if (state is SubjectSyncSuccess) {
              return FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.quizSelection,
                    arguments: QuizScreenArgs(
                      subjectId: widget.subject.id,
                      textDirection: widget.textDirection,
                      subjectColor: subjectColor,
                    ),
                  );
                },
                label: Icon(Icons.shuffle),
              );
            }
            return SizedBox.shrink();
          },
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: subjectColor,
            statusBarIconBrightness:
                Theme.of(context).brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light,
          ),
          child: SafeArea(
            child: BlocConsumer<SubjectSyncCubit, SubjectSyncState>(
              listener: (context, state) {
                if (state is SubjectSyncFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              },
              builder: (context, state) {
                switch (state) {
                  case SubjectSyncInitial():
                    return SizedBox();
                  case SubjectSyncLoading():
                    return Center(
                      child: CoolLoadingScreen(
                        primaryColor: subjectColor,
                        secondaryColor: subjectColor.withAlpha(100),
                      ),
                    );
                  case SubjectSyncSuccess():
                    return Column(
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
                              BlocBuilder<LessonsCubit, LessonsState>(
                                builder: (context, state) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${state is LessonsLoaded ? state.answeredQuestionsCount : 0}/${state is LessonsLoaded ? state.questionsCount : 100}",
                                        style: TextStyle(
                                            color: colorScheme.onPrimary),
                                      ),
                                      // const SizedBox(height: 8),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value: state is LessonsLoaded
                                              ? state.answeredQuestionsCount /
                                                  state.questionsCount
                                              : 0 / 100,
                                          backgroundColor:
                                              colors.white.withAlpha(77),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  colors.white),
                                          minHeight: 8,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${widget.subject.numberOfLessons} درس',
                                    style: TextStyle(
                                      color: colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    child: AnimatedRaisedButtonWithChild(
                                      onPressed: () async {
                                        final Uri url =
                                            Uri.parse(widget.subject.link);
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url);
                                        } else {
                                          log('لا يوجد رابط لهذا المادة');
                                        }
                                      },
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerLow,
                                      shadowColor: getIt<AppTheme>().isDark
                                          ? Colors.blueGrey.withAlpha(200)
                                          : null,
                                      width: 150,
                                      shadowOffset: 5,
                                      lerpValue: 0.1,
                                      borderWidth: 2.5,
                                      borderRadius: BorderRadius.circular(12),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.link,
                                            color: subjectColor,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "رابط التليجرام",
                                            style: TextStyle(
                                              color: subjectColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              BlocProvider.value(
                                value: regularLessonsCubit
                                  ..getRegularLessons(widget.subject.id),
                                child: LessonsTab(
                                  subject: widget.subject,
                                  subjectColor: subjectColor,
                                  direction: widget.textDirection,
                                ),
                              ),
                              BlocProvider.value(
                                value: incorrectLessonsCubit
                                  ..getIncorrectLessons(widget.subject.id),
                                child: LessonsTab(
                                  subject: widget.subject,
                                  subjectColor: subjectColor,
                                  direction: widget.textDirection,
                                ),
                              ),
                              BlocProvider.value(
                                value: favLessonsCubit
                                  ..getFavLessons(widget.subject.id),
                                child: LessonsTab(
                                  subject: widget.subject,
                                  subjectColor: subjectColor,
                                  direction: widget.textDirection,
                                ),
                              ),
                              BlocProvider.value(
                                value: tagCubit
                                  ..fetchTagsOrExams(
                                    subjectId: widget.subject.id,
                                    isExam: false,
                                  ),
                                child: AllTagsTab(
                                  color: subjectColor,
                                  direction: widget.textDirection,
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
                                  direction: widget.textDirection,
                                ),
                              ),
                              BlocProvider.value(
                                value: editedLessonsCubit
                                  ..getEditedLessons(widget.subject.id),
                                child: LessonsTab(
                                  subject: widget.subject,
                                  subjectColor: subjectColor,
                                  direction: widget.textDirection,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  case SubjectSyncFailure():
                    return Center(
                      child: Text(state.message),
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LessonsTab extends StatelessWidget {
  final Color subjectColor;
  final SubjectEntity subject;
  final TextDirection direction;

  const LessonsTab({
    super.key,
    required this.subjectColor,
    required this.subject,
    required this.direction,
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
            textDirection: direction,
          ),
        ),
      ],
    );
  }
}

class LessonsGridView extends StatefulWidget {
  final Color subjectColor;
  final SubjectEntity subject;
  final TextDirection textDirection;

  const LessonsGridView({
    super.key,
    required this.subjectColor,
    required this.subject,
    required this.textDirection,
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
          case LessonsLoading():
            return Center(
              child: CoolLoadingScreen(
                primaryColor: widget.subjectColor,
                secondaryColor: widget.subjectColor.withAlpha(100),
              ),
            );

          case LessonsLoaded():
            state.lessons.removeWhere((ele) => ele.questionTypes.isEmpty);
            return _lessonsListView(
              state.lessons,
            );

          case LessonsError():
            return Center(
              child: Text(state.message),
            );

          case LessonsInitial():
            return Center(
              child: SizedBox(),
            );
        }
      },
    );
  }

  Widget _lessonsListView(List<LessonEntity> lessons) {
    return RefreshIndicator(
      onRefresh: () async {
        await context
            .read<SubjectSyncCubit>()
            .getSubjectSync(widget.subject.id, isRefresh: true);
      },
      child: lessons.isEmpty
          ? _emptyStateScreen()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) => Column(
                children: [
                  LessonCard(
                    lesson: lessons[index],
                    subject: widget.subject,
                    isExpanded: _expandedLessons[index] ?? false,
                    onTap: () => _toggleLesson(index),
                    subjectColor: widget.subjectColor,
                    textDirection: widget.textDirection,
                  ),
                  SizedBox(height: 16),
                ],
              ),
              itemCount: lessons.length,
            ),
    );
  }

  Widget _emptyStateScreen() {
    switch (context.read<LessonsCubit>().screenType) {
      case ScreenType.regularLessons:
        return EmptyStateScreen(
          title: 'لا يوجد دروس',
          message: 'لا يوجد دروس لهذا المادة',
          icon: Icons.book,
          iconColor: widget.subjectColor,
          textColor: widget.subjectColor,
        );
      case ScreenType.editedLessons:
        return EmptyStateScreen(
          title: 'لا يوجد أسئلة معدلة',
          message: 'لا يوجد أسئلة معدلة لهذا المادة',
          iconColor: widget.subjectColor,
          textColor: widget.subjectColor,
        );
      case ScreenType.incorrectLessons:
        return EmptyStateScreen(
          title: 'لا يوجد أسئلة خاطئة',
          message: 'لا يوجد أسئلة خاطئة لهذا المادة',
          iconColor: widget.subjectColor,
          textColor: widget.subjectColor,
        );
      case ScreenType.favLessons:
        return EmptyStateScreen(
          title: 'لا يوجد أسئلة مفضلة',
          message: 'لا يوجد أسئلة مفضلة لهذا المادة',
          iconColor: widget.subjectColor,
          textColor: widget.subjectColor,
        );
    }
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
  final TextDirection textDirection;

  const LessonCard({
    super.key,
    required this.isExpanded,
    required this.onTap,
    required this.subjectColor,
    required this.subject,
    required this.lesson,
    required this.textDirection,
  });

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AnimatedRaisedButtonWithChild(
      height: 160,
      backgroundColor: colors.surfaceContainerLow,
      shadowColor:
          getIt<AppTheme>().isDark ? Colors.blueGrey.withAlpha(70) : null,
      // shadowColor: ,
      onPressed: () async {
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
      child: widget.isExpanded
          ? _buildExpandedContent(colors)
          : _buildCollapsedContent(),
    );
  }

  Widget _buildCollapsedContent() {
    return Center(
      child: Text(
        widget.lesson.title,
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
    if (widget.subject.isLocked == 1 &&
        widget.lesson.questionTypes.length == 1) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock,
            ),
            SizedBox(width: 12),
            Text(
              "عذرا اشترك بالمادة لفتح الدرس",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
    return AnimatedAdaptiveGridLayout(
      spacing: 8,
      // controller: _scrollController,
      // cacheExtent: 0,
      padding: EdgeInsets.only(
        right: 8,
      ),
      rowHeight: widget.lesson.questionTypes.length <= 4 ? 135 : 65,
      itemBuilder: (context, index) {
        return AnimatedRaisedButtonWithChild(
          backgroundColor: colors.surfaceContainerLow,
          shadowColor:
              getIt<AppTheme>().isDark ? Colors.blueGrey.withAlpha(70) : null,
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
                "direction": widget.textDirection,
                "screenType": context.read<LessonsCubit>().screenType,
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
        );
      },
      itemCount: widget.lesson.questionTypes.length,
    );
  }
}
