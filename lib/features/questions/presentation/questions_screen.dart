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

import '../../../core/theme/theme.dart';
import '../../../core/utils/constants/app_numbers.dart';
import '../../../core/utils/constants/constant.dart';
import '../../../core/utils/services/service_locator.dart';
import '../../auth/presentation/widgets/animated_raised_button.dart';
import '../domain/entities/question_entity.dart';

class QuestionsPage extends StatefulWidget {
  final String lessonName;
  final Color subjectColor;

  const QuestionsPage({
    super.key,
    required this.lessonName,
    required this.subjectColor,
  });

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  // int correctAnswers = 0;
  // int wrongAnswers = 0;
  // Timer? timer;
  // int seconds = 0;
  // bool isTimerRunning = false;
  // bool isInitialized = false;
  // List<int?> userAnswers = [];
  // List<bool?> isCorrect = [];

  // Map<int, bool> isFavorite = {};
  // Map<int, String> userNotes = {};
  // Map<int, bool> expandedImages = {};
  // Map<int, bool> expandedAnswers = {};
  // TextEditingController noteController = TextEditingController();
  // FocusNode noteFocusNode = FocusNode();

  @override
  void initState() {
    // userAnswers = List.generate(widget.questions.length, (index) => null);
    // isCorrect = List.generate(widget.questions.length, (index) => null);
    super.initState();
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void showHintBottomSheet(BuildContext context, String hint) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
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
            Text(
              hint,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> showConfirmationDialog(String action, VoidCallback onConfirm) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Confirm $action',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('Are you sure you want to $action?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          AnimatedRaisedButtonWithChild(
            width: 130,
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: action == 'reset' ? Colors.red : widget.subjectColor,
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
                  action == 'reset' ? 'Reset' : 'Check All',
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

  void showNoteBottomSheet(BuildContext context, int questionIndex, Map<int, String>? userNotes) {
    final questionCubit = context.read<QuestionCubit>();
    questionCubit.noteController.text = userNotes?[questionIndex] ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
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
                            'Question ${questionIndex + 1} Notes',
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
                            hintText: 'Add your notes here...',
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
                              label: const Text('Save Note'),
                              onPressed: () {
                                if (questionCubit.noteController.text.trim().isNotEmpty) {
                                  this.setState(() {
                                    userNotes?[questionIndex] = questionCubit.noteController.text.trim();
                                  });
                                } else {
                                  this.setState(() {
                                    userNotes?.remove(questionIndex);
                                  });
                                }
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          if (userNotes?.containsKey(questionIndex) ?? false) ...[
                            const SizedBox(width: 12),
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.delete),
                              label: const Text('Delete'),
                              onPressed: () {
                                this.setState(() {
                                  userNotes?.remove(questionIndex);
                                  questionCubit.noteController.clear();
                                });
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionCubit = context.read<QuestionCubit>();
    return Scaffold(
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
            _ => const Center(child: CircularProgressIndicator()),
          };
        },
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
                    //todo: quill editor go here
                    child: QuillEditor(
                      focusNode: questionCubit.getQuestionFocusNode(questionIndex),
                      controller: questionCubit.getQuestionController(questionIndex),
                      scrollController: questionCubit.getQuestionScrollController(questionIndex),
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
                  ),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: question.questionPhoto ?? '',
                      placeholder: (context, url) => Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.error_outline, size: 40, color: Colors.grey),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ],
              if (question.type == QuestionType.written) ...[
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: Colors.grey[200],
                    child: Padding(
                      padding: EdgeInsets.all(padding4),
                      child: GestureDetector(
                        onTap: () {
                          context.read<QuestionCubit>().toggleExpandedAnswer(questionIndex);
                        },
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
                              : Icon(
                                  state.expandedAnswers[questionIndex] == true ? Icons.visibility_off : Icons.question_answer_outlined,
                                  color: widget.subjectColor,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              if (question.type == QuestionType.multipleChoice) _buildMultipleChoiceAnswers(question, questionIndex, state) else _buildAnswer(question, questionIndex),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(
                    icon: Icons.lightbulb_outline,
                    color: Color(0xFFFFB347),
                    onPressed: () => showHintBottomSheet(
                      context,
                      "",
                      // question.hint ?? 'No hint available', //todo : here quill editor go
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    icon: state.isFavorite[questionIndex] == true ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        state.isFavorite[questionIndex] = !(state.isFavorite[questionIndex] ?? false);
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    icon: state.userNotes.containsKey(questionIndex) ? Icons.note : Icons.note_add,
                    color: widget.subjectColor,
                    onPressed: () => showNoteBottomSheet(context, questionIndex, state.userNotes),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    icon: Icons.campaign_outlined,
                    color: Colors.red,
                    onPressed: () => _showReportOptions(context),
                  ),
                  if (question.type == QuestionType.multipleChoice) ...[
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
    final questionCubit = context.read<QuestionCubit>();
    return Column(
      children: question.choices.map((answer) {
        // log("${userAnswers[index] ?? "this is null"}");
        bool isSelected = question.choices.indexOf(answer) == state.userAnswers[questionIndex];
        bool isCorrect = question.choices.indexOf(answer) == question.rightChoice;
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
              child: IgnorePointer(
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
              onLongPressed: () => showConfirmationDialog('check all answers?', context.read<QuestionCubit>().checkAllAnswers),
              onPressed: () => showConfirmationDialog('check your answers?', context.read<QuestionCubit>().checkUserAnswersOnly),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Check answers',
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
              onPressed: () => showConfirmationDialog('reset', context.read<QuestionCubit>().resetAnswers),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Reset',
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

enum QuestionType { multipleChoice, written }

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

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Math.tex(
        formula,
        textStyle: embedContext.textStyle,
        mathStyle: MathStyle.display,
      ),
    );
  }
}
