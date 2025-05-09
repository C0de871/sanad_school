// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sanad_school/features/questions/presentation/cubit/question_cubit.dart';
import 'package:sanad_school/features/questions/presentation/cubit/question_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import '../../../core/shared/widgets/animated_loading_screen.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/constants/app_numbers.dart';
import '../../../core/utils/constants/constant.dart';
import '../../../core/utils/services/service_locator.dart';
import '../../auth/presentation/widgets/animated_raised_button.dart';
import '../domain/entities/question_entity.dart';

class QuestionsPage extends StatefulWidget {
  final String lessonName;
  final Color subjectColor;
  final TextDirection textDirection;

  const QuestionsPage({
    super.key,
    required this.lessonName,
    required this.subjectColor,
    required this.textDirection,
  });

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  @override
  void initState() {
    super.initState();
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void showHintBottomSheet(BuildContext parentContext, int questionIndex, QuestionSuccess state) {
    final questionCubit = parentContext.read<QuestionCubit>();
    showModalBottomSheet(
      context: parentContext,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BlocProvider.value(
        value: questionCubit,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.lightbulb, color: widget.subjectColor),
                  const SizedBox(width: 12),
                  Text(
                    'Hint',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.subjectColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Text(
              //   hint,
              //   style: const TextStyle(fontSize: 16, height: 1.5),
              // ),
              QuillEditor(
                focusNode: questionCubit.getHintFocusNode(questionIndex),
                controller: questionCubit.getHintController(questionIndex),
                scrollController: questionCubit.getHintScrollController(questionIndex),
                config: QuillEditorConfig(
                  scrollable: false,
                  requestKeyboardFocusOnCheckListChanged: false,
                  showCursor: false,
                  autoFocus: false,
                  padding: EdgeInsets.zero,
                  embedBuilders: [
                    FormulaEmbedBuilder(),
                  ],
                ),
                // question.textQuestion,
                // style: const TextStyle(
                //   fontSize: 16,
                //   fontWeight: FontWeight.bold,
                //   height: 1.4,
                // ),
              ),
              const SizedBox(height: 16),
              if (state.questions[questionIndex].hintPhoto != null)
                BlocBuilder<QuestionCubit, QuestionState>(
                  // buildWhen: (previous, current) {
                  // if (current is QuestionSuccess && previous is QuestionSuccess) {
                  //   return previous.questions[questionIndex].downloadedHintPhoto != current.questions[questionIndex].downloadedHintPhoto;
                  // }
                  // return false;
                  // },
                  builder: (context, state) {
                    switch (state) {
                      case QuestionSuccess():
                        if (state.questions[questionIndex].downloadedHintPhoto != null) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.memory(
                              state.questions[questionIndex].downloadedHintPhoto!,
                              // imageUrl: state.questions[questionIndex].hintPhoto!,
                              // placeholder: (context, url) => Container(
                              //   height: 200,
                              //   color: Colors.grey[200],
                              //   child: const Center(child: CoolLoadingScreen()),
                              // ),
                              // errorWidget: (context, url, error) => Container(
                              //   height: 200,
                              //   color: Colors.grey[200],
                              //   child: const Center(
                              //     child: Icon(Icons.error_outline, size: 40, color: Colors.grey),
                              //   ),
                              // ),
                              fit: BoxFit.cover,
                            ),
                          );
                        } else if (state.questions[questionIndex].hintPhoto != null) {
                          return const Center(child: CoolLoadingScreen());
                        } else {
                          return const SizedBox();
                        }
                      case QuestionInitial():
                        return const SizedBox();
                      case QuestionLoading():
                        return const Center(child: CoolLoadingScreen());
                      case QuestionFailure():
                        return const SizedBox();
                    }
                  },
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext parentContext) {
    showGeneralDialog(
      context: parentContext,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BlocProvider.value(
          value: parentContext.read<QuestionCubit>(),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'أحسنت',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<QuestionCubit, QuestionState>(
                    builder: (context, state) {
                      return switch (state) {
                        QuestionSuccess() => Column(
                            children: [
                              Text(
                                'لقد اجبت على',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '${state.correctAnswers} اجابة صحيحة',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'و ${state.wrongAnswers} اجابة خاطئة',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'نسبة الاجابات الصحيحة ${(state.correctAnswers / state.questions.length * 100).toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        _ => const SizedBox(),
                      };
                    },
                  ),
                  const SizedBox(height: 24),
                  AnimatedRaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: 'تم',
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shadowColor: getIt<AppTheme>().extendedColors.buttonShadow,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showConfirmationDialog(bool isReset, String action, VoidCallback onConfirm) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          action,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('هل أنت متأكد أنك تريد $action?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          AnimatedRaisedButtonWithChild(
            width: 130,
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: isReset ? Colors.red : widget.subjectColor,
            borderRadius: BorderRadius.circular(10),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  isReset ? 'إعادة تعيين' : 'تحقق ',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showNoteBottomSheet(BuildContext parentContext, int questionIndex, QuestionEntity question, String? note) {
    final questionCubit = parentContext.read<QuestionCubit>();
    questionCubit.noteController.text = note ?? '';

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: questionCubit,
        child: StatefulBuilder(
          builder: (context, setState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.note_add, color: widget.subjectColor),
                            const SizedBox(width: 12),
                            Text(
                              'ملاحظات السؤال ${questionIndex + 1}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: widget.subjectColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: widget.subjectColor.withOpacity(0.2),
                            ),
                          ),
                          child: TextField(
                            controller: questionCubit.noteController,
                            focusNode: questionCubit.noteFocusNode,
                            maxLines: 5,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'أضف ملاحظاتك هنا...',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              contentPadding: const EdgeInsets.all(16),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  backgroundColor: widget.subjectColor,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.save),
                                label: const Text('حفظ الملاحظة'),
                                onPressed: () {
                                  if (questionCubit.noteController.text.trim().isNotEmpty) {
                                    questionCubit.saveQuestionNote(questionId: question.id, note: questionCubit.noteController.text.trim());
                                  } else {
                                    questionCubit.saveQuestionNote(questionId: question.id, note: '');
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            if (question.note != null && question.note!.trim().isNotEmpty) ...[
                              const SizedBox(width: 12),
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Icon(Icons.delete, color: Colors.white),
                                onPressed: () {
                                  questionCubit.saveQuestionNote(questionId: question.id, note: '');
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionCubit = context.read<QuestionCubit>();
    return Directionality(
      textDirection: widget.textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.lessonName),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(58),
            child: Container(
              padding: EdgeInsets.only(bottom: padding4 * 2),
              decoration: BoxDecoration(
                // color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: BlocBuilder<QuestionCubit, QuestionState>(
                builder: (context, state) {
                  return switch (state) {
                    QuestionSuccess() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildEnhancedStatCard(
                            'Total Questions',
                            state.questions.length.toString(),
                            Icons.quiz,
                            Color(0xFF84D6FD),
                          ),
                          _buildEnhancedStatCard(
                            'Correct',
                            state.correctAnswers.toString(),
                            Icons.check_circle,
                            Color(0xFFA7EF75),
                          ),
                          _buildEnhancedStatCard(
                            'Wrong',
                            state.wrongAnswers.toString(),
                            Icons.cancel,
                            Color.fromARGB(255, 254, 117, 117),
                          ),
                        ],
                      ),
                    _ => SizedBox(),
                  };
                },
              ),
            ),
          ),
          actions: [
            BlocBuilder<QuestionCubit, QuestionState>(
              builder: (context, state) {
                return switch (state) {
                  QuestionSuccess() => GestureDetector(
                      onLongPress: () {
                        questionCubit.resetTimer();
                      },
                      child: IconButton(
                        icon: const Icon(Icons.timer),
                        onPressed: () {
                          if (state.isTimerRunning) {
                            questionCubit.stopTimer();
                          } else {
                            questionCubit.startTimer();
                          }
                        },
                      ),
                    ),
                  _ => SizedBox(),
                };
              },
            ),
            BlocBuilder<QuestionCubit, QuestionState>(
              builder: (context, state) {
                return switch (state) {
                  QuestionSuccess() => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Center(
                        child: Text(
                          formatTime(state.seconds),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  _ => SizedBox(),
                };
              },
            ),
          ],
        ),
        body: BlocBuilder<QuestionCubit, QuestionState>(
          builder: (context, state) {
            return switch (state) {
              QuestionSuccess() => Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: state.questions.length,
                            itemBuilder: (context, index) {
                              final question = state.questions[index];
                              return _buildQuestionCard(question, index, state);
                            },
                          ),
                        ),
                        SizedBox(height: 64),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _buildBottomActionBar(),
                    ),
                  ],
                ),
              _ => const Center(child: CoolLoadingScreen()),
            };
          },
        ),
      ),
    );
  }

  Widget _buildEnhancedStatCard(String title, String value, IconData icon, Color color) {
    return SizedBox(
      // width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 8),
                Text(
                  " : $value",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuestionEntity question, int questionIndex, QuestionSuccess state) {
    log("expanded state is ${state.expandedImages[questionIndex]}");
    log("question photo state is ${question.downloadedQuestionPhoto != null}");
    final questionCubit = context.read<QuestionCubit>();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.subjectColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '${questionIndex + 1}',
                        style: TextStyle(
                          color: widget.subjectColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: QuillEditor(
                      focusNode: questionCubit.getQuestionFocusNode(questionIndex),
                      controller: questionCubit.getQuestionController(questionIndex),
                      scrollController: questionCubit.getQuestionScrollController(questionIndex),
                      config: QuillEditorConfig(
                        scrollable: true, // Disable QuillEditor's internal scrolling
                        requestKeyboardFocusOnCheckListChanged: false,
                        showCursor: false,
                        autoFocus: false,
                        padding: EdgeInsets.zero,
                        embedBuilders: [
                          FormulaEmbedBuilder(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              if (question.questionPhoto != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: widget.subjectColor.withOpacity(0.1),
                      ),
                      icon: Icon(
                        state.expandedImages[questionIndex] == true ? Icons.visibility_off : Icons.image,
                        color: widget.subjectColor,
                      ),
                      onPressed: () {
                        context.read<QuestionCubit>().toggleExpandedImage(questionIndex);
                      },
                    ),
                  ],
                ),
                if (state.expandedImages[questionIndex] == true) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: question.downloadedQuestionPhoto != null
                          ? Image.memory(
                              question.downloadedQuestionPhoto!,
                              height: 350,
                              // imageUrl: question.questionPhoto ?? '',
                              // placeholder: (context, url) => Container(
                              //   height: 200,
                              //   color: Colors.grey[200],
                              //   child: const Center(child: CoolLoadingScreen()),
                              // ),
                              // errorWidget: (context, url, error) => Container(
                              //   height: 200,
                              //   color: Colors.grey[200],
                              //   child: const Center(
                              //     child: Icon(Icons.error_outline, size: 40, color: Colors.grey),
                              //   ),
                              // ),
                              fit: BoxFit.contain,
                            )
                          : Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: const Center(child: CoolLoadingScreen()),
                            ),
                    ),
                  ),
                ],
              ],
              if (question.type == QuestionTypeEnum.written) ...[
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    context.read<QuestionCubit>().toggleExpandedAnswer(questionIndex);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      color: Colors.grey[200],
                      child: Padding(
                        padding: EdgeInsets.all(padding4 * 4),
                        child: Center(
                          child: state.expandedAnswers[questionIndex] == true
                              ? QuillEditor(
                                  focusNode: questionCubit.getAnswerFocusNode(questionIndex, 0),
                                  controller: questionCubit.getAnswerController(questionIndex, 0),
                                  scrollController: questionCubit.getAnswerScrollController(questionIndex, 0),
                                  config: QuillEditorConfig(
                                    scrollable: false,
                                    showCursor: false,
                                    autoFocus: false,
                                    requestKeyboardFocusOnCheckListChanged: false,
                                    padding: EdgeInsets.zero,
                                    embedBuilders: [
                                      FormulaEmbedBuilder(),
                                    ],
                                  ),
                                  // question.answers[0], //todo: here the quill editor go
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      state.expandedAnswers[questionIndex] == true ? Icons.visibility_off : Icons.question_answer_outlined,
                                      color: widget.subjectColor,
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      'عرض الاجابة',
                                      style: TextStyle(color: widget.subjectColor),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              if (question.type == QuestionTypeEnum.multipleChoice) _buildMultipleChoiceAnswers(question, questionIndex, state) else _buildAnswer(question, questionIndex),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state.questions[questionIndex].hint != null || state.questions[questionIndex].hintPhoto != null)
                    _buildActionButton(
                      icon: Icons.lightbulb_outline,
                      color: Color(0xFFFFB347),
                      onPressed: () {
                        if (state.questions[questionIndex].downloadedHintPhoto == null) {
                          questionCubit.getQuestionHintPhoto(state.questions[questionIndex].id, state.questions[questionIndex].hintPhoto!);
                        }
                        showHintBottomSheet(
                          context,
                          questionIndex,
                          state,
                        );
                      },
                    ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    icon: question.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    onPressed: () {
                      context.read<QuestionCubit>().toggleQuestionFavorite(questionId: question.id, isFavorite: !question.isFavorite);
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    icon: question.note != null && question.note!.trim().isNotEmpty ? Icons.note : Icons.note_add,
                    color: widget.subjectColor,
                    onPressed: () => showNoteBottomSheet(context, questionIndex, question, question.note),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    icon: Icons.campaign_outlined,
                    color: Colors.red,
                    onPressed: () => _showReportOptions(context),
                  ),
                  if (question.type == QuestionTypeEnum.multipleChoice) ...[
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.check,
                      color: Colors.green,
                      onPressed: () => context.read<QuestionCubit>().checkMultipleChoiceAnswer(questionIndex),
                    ),
                  ] else ...[
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.check,
                      color: Colors.green,
                      onPressed: () => context.read<QuestionCubit>().checkWrittenAnswer(questionIndex, true),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.close,
                      color: Colors.red,
                      onPressed: () => context.read<QuestionCubit>().checkWrittenAnswer(questionIndex, false),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
                title: const Text('Report via WhatsApp'),
                onTap: () {
                  Navigator.pop(context);
                  _launchWhatsApp();
                },
              ),
              ListTile(
                leading: const Icon(Icons.telegram, color: Colors.blue),
                title: const Text('Report via Telegram'),
                onTap: () {
                  Navigator.pop(context);
                  _launchTelegram();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _launchWhatsApp() async {
    // Make sure the phone number includes country code and no special characters
    String formattedNumber = Constant.whatsappNumber;

    // Try direct WhatsApp app URI first
    final whatsappUri = Uri.parse('whatsapp://send?phone=$formattedNumber&text=I want to report an issue');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      // Fallback to web URL
      final webUri = Uri.parse('https://wa.me/$formattedNumber?text=I want to report an issue');
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch WhatsApp');
      }
    }
  }

  void _launchTelegram() async {
    // Try direct Telegram app URI first
    final telegramUri = Uri.parse('tg://resolve?domain=${Constant.telegramUsername}');

    if (await canLaunchUrl(telegramUri)) {
      await launchUrl(telegramUri);
    } else {
      // Fallback to web URL
      final webUri = Uri.parse('https://t.me/${Constant.telegramUsername}');
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch Telegram');
      }
    }
  }

  Widget _buildAnswer(QuestionEntity question, int index) {
    return Container(decoration: BoxDecoration());
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildMultipleChoiceAnswers(QuestionEntity question, int questionIndex, QuestionSuccess state) {
    log("right choice for question id ${question.id} is ${question.adjustedRightChoice} , and the index of question is $questionIndex");
    final questionCubit = context.read<QuestionCubit>();
    return Column(
      children: question.choices.map((answer) {
        // log("${userAnswers[index] ?? "this is null"}");
        bool isSelected = question.choices.indexOf(answer) == state.userAnswers[questionIndex];
        bool isCorrect = question.choices.indexOf(answer) == question.adjustedRightChoice;
        bool isQuestionCorrected = state.isCorrect[questionIndex] != null;

        Color shadowColor = Colors.blueGrey.withAlpha(70);
        Color backgroundColor = Theme.of(context).colorScheme.surfaceContainerLow;
        Color textColor = Colors.blueGrey;

        if (isQuestionCorrected) {
          log("question corrected");
          if (isCorrect) {
            log("the correct answer");
            shadowColor = Color(0xFFA7EF75);
            textColor = Color.fromARGB(255, 69, 165, 0);
            backgroundColor = Color(0xFFD7FFB8);
          } else if (isSelected) {
            log("user answer incorrect");
            shadowColor = Color.fromARGB(255, 254, 117, 117);
            textColor = Color.fromARGB(255, 242, 89, 89);
            backgroundColor = Color(0xFFFFDFE0);
          }
        } else {
          log("question isn't corrected");
          if (isSelected) {
            log("answer is selected");
            shadowColor = Color(0xFF84D6FD);
            textColor = Color.fromARGB(255, 91, 203, 255);
            backgroundColor = Color(0xFFDDF3FE);
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: AnimatedRaisedButtonWithChild(
            isDisable: isQuestionCorrected,
            backgroundColor: backgroundColor,
            shadowColor: getIt<AppTheme>().isDark ? shadowColor : shadowColor,
            shadowOffset: 3,
            lerpValue: 0.1,
            borderWidth: 1.5,
            padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            borderRadius: BorderRadius.circular(16),
            onPressed: isQuestionCorrected
                ? null
                : () {
                    setState(() {
                      state.userAnswers[questionIndex] = question.choices.indexOf(answer);
                    });
                  },
            child: Center(
              child: QuillEditor(
                focusNode: questionCubit.getAnswerFocusNode(questionIndex, question.choices.indexOf(answer)),
                controller: questionCubit.getAnswerController(questionIndex, question.choices.indexOf(answer)),
                scrollController: questionCubit.getAnswerScrollController(questionIndex, question.choices.indexOf(answer)),
                config: QuillEditorConfig(
                  scrollable: false,
                  requestKeyboardFocusOnCheckListChanged: false,
                  showCursor: false,
                  autoFocus: false,
                  padding: EdgeInsets.zero,
                  enableInteractiveSelection: false,
                  embedBuilders: [
                    FormulaEmbedBuilder(),
                  ],
                ),
                // answer, //todo: here the quill editor go
                // style: TextStyle(
                //   fontSize: 14,
                //   color: textColor,
                //   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                // ),
                // textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: AnimatedRaisedButtonWithChild(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: widget.subjectColor,
              borderRadius: BorderRadius.circular(16),
              onLongPressed: () => showConfirmationDialog(false, 'التحقق من جميع الأسئلة', () {
                context.read<QuestionCubit>().checkAllAnswers();
                _showSuccessDialog(context);
              }),
              onPressed: () => showConfirmationDialog(false, 'التحقق من إجاباتك', () {
                context.read<QuestionCubit>().checkUserAnswersOnly();
                _showSuccessDialog(context);
              }),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'تحقق من الأسئلة',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AnimatedRaisedButtonWithChild(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(16),
              onPressed: () => showConfirmationDialog(true, 'إعادة تعيين الإجابات', context.read<QuestionCubit>().resetAnswers),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'إعادة تعيين',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  @override
  void dispose() {
    super.dispose();
  }
}

enum QuestionTypeEnum { multipleChoice, written }

// Custom formula embed builder
class FormulaEmbedBuilder extends EmbedBuilder {
  @override
  String get key => 'formula';

  @override
  Widget build(
    BuildContext context,
    EmbedContext embedContext,
  ) {
    final formula = embedContext.node.value.data;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Math.tex(
            formula,
            textStyle: embedContext.textStyle,
            mathStyle: MathStyle.display,
          ),
        ),
      ),
    );
  }
}
