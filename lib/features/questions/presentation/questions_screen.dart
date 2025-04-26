// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import '../../../core/theme/theme.dart';
import '../../../core/utils/constants/app_numbers.dart';
import '../../../core/utils/constants/constant.dart';
import '../../../core/utils/services/service_locator.dart';
import '../../auth/presentation/widgets/animated_raised_button.dart';

final List<Question> sampleQuestions = [
  Question(
    text: "ما هو الوظيفة الأساسية لعملية البناء الضوئي في النباتات؟",
    type: QuestionType.multipleChoice,
    answers: [
      "تحويل الطاقة الضوئية إلى طاقة كيميائية",
      "إنتاج الأكسجين فقط",
      "امتصاص الماء من التربة",
      "نمو الأوراق",
    ],
    correctAnswer: 0,
    hasImage: true,
    hint: "فكر في كيفية صنع النباتات غذاءها باستخدام ضوء الشمس",
    imageUrl: "assets/images/photosynthesis.png",
  ),
  Question(
    text: "حل المعادلة: 2x + 5 = 13",
    type: QuestionType.multipleChoice,
    answers: [
      "x = 4",
      "x = 6",
      "x = 8",
      "x = 3",
    ],
    correctAnswer: 2,
    hasImage: false,
    hint: "اطرح 5 من الطرفين ثم اقسم على 2",
  ),
  Question(
    text: "اشرح بكلماتك الخاصة كيف تعمل دورة الماء. قم بتضمين المراحل الأساسية في الشرح.",
    answers: ["جواب السؤال"],
    type: QuestionType.written,
    hasImage: true,
    hint: "تذكر المصطلحات: التبخر، التكاثف، والهطول",
    imageUrl: "assets/images/water_cycle.png",
  ),
  Question(
    text: "أي كوكب يُعرف باسم 'الكوكب الأحمر'؟",
    type: QuestionType.multipleChoice,
    answers: ["الزهرة", "المريخ", "المشتري", "زحل"],
    correctAnswer: 1,
    hasImage: true,
    hint: "يعود لونه إلى أكسيد الحديد (الصدأ) على سطحه",
    imageUrl: "assets/images/mars.png",
  ),
  Question(
    text: "ما هو الموضوع الرئيسي في مسرحية 'روميو وجولييت' لشكسبير؟",
    type: QuestionType.multipleChoice,
    answers: [
      "الحب المحرم",
      "السلطة السياسية",
      "الثروة العائلية",
      "الحروب في العصور الوسطى",
    ],
    correctAnswer: 0,
    hasImage: false,
    hint: "فكر في العلاقة بين الشخصيتين الرئيسيتين وعائلتيهما",
  ),
  Question(
    text: "صف عملية الانقسام المتساوي في الخلية. ما هي مراحله الأساسية؟",
    type: QuestionType.written,
    hasImage: true,
    answers: ["جواب السؤال"],
    hint: "تذكر: الطور التمهيدي، الطور الاستوائي، الطور الانفصالي، الطور النهائي",
    imageUrl: "assets/images/mitosis.png",
  ),
  Question(
    text: "ما قيمة π (باي) لأقرب منزلتين عشريتين؟",
    type: QuestionType.multipleChoice,
    answers: [
      "3.12",
      "3.14",
      "3.16",
      "3.18",
    ],
    correctAnswer: 1,
    hasImage: false,
    hint: "يستخدم هذا الرقم لحساب محيط الدائرة",
  ),
  Question(
    text: "ما الذي يسبب تغير الفصول على الأرض؟",
    type: QuestionType.multipleChoice,
    answers: [
      "ميلان محور الأرض",
      "المسافة عن الشمس",
      "سرعة الدوران",
      "الضغط الجوي",
    ],
    correctAnswer: 0,
    hasImage: true,
    hint: "فكر في ميلان الأرض بزاوية 23.5 درجة",
    imageUrl: "assets/images/seasons.png",
  ),
  Question(
    text: "اشرح مفهوم الكثافة وقدم مثالًا من الحياة اليومية.",
    type: QuestionType.written,
    answers: ["جواب السؤال"],
    hasImage: false,
    hint: "فكر في سبب طفو بعض الأجسام وغرق الأخرى",
  ),
  Question(
    text: "ما هي الصيغة الكيميائية للماء؟",
    type: QuestionType.multipleChoice,
    answers: [
      "H2O",
      "CO2",
      "O2",
      "H2O2",
    ],
    correctAnswer: 0,
    hasImage: false,
    hint: "يتكون من ذرتين هيدروجين وذرة أكسجين واحدة",
  ),
  Question(
    text: "صف أهمية إعلان الاستقلال. ما هي أهدافه الرئيسية؟",
    type: QuestionType.written,
    hasImage: true,
    answers: ["جواب السؤال"],
    hint: "فكر في تأثيره الفوري وطويل الأمد تاريخيًا",
    imageUrl: "assets/images/declaration.png",
  ),
  Question(
    text: "أي من هذه الألوان هو لون أساسي؟",
    type: QuestionType.multipleChoice,
    answers: [
      "الأخضر",
      "البنفسجي",
      "الأزرق",
      "البرتقالي",
    ],
    correctAnswer: 2,
    hasImage: true,
    hint: "الألوان الأساسية لا يمكن الحصول عليها بخلط ألوان أخرى",
    imageUrl: "assets/images/colors.png",
  ),
  Question(
    text: "ما الفرق بين الطقس والمناخ؟",
    type: QuestionType.written,
    answers: ["جواب السؤال"],
    hasImage: false,
    hint: "فكر في الفرق بين الأنماط قصيرة الأمد وطويلة الأمد",
  ),
  Question(
    text: "أي عضي يُعرف باسم 'محطة الطاقة' في الخلية؟",
    type: QuestionType.multipleChoice,
    answers: [
      "الميتوكندريا",
      "النواة",
      "جهاز جولجي",
      "الشبكة الإندوبلازمية",
    ],
    correctAnswer: 0,
    hasImage: true,
    hint: "هذا العضي ينتج الطاقة من خلال التنفس الخلوي",
    imageUrl: "assets/images/cell.png",
  )
];
//Screen:

class QuestionsPage extends StatefulWidget {
  final String lessonName;
  final List<Question> questions;
  final Color subjectColor;

  const QuestionsPage({
    super.key,
    required this.lessonName,
    required this.questions,
    required this.subjectColor,
  });

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  int correctAnswers = 0;
  int wrongAnswers = 0;
  Timer? timer;
  int seconds = 0;
  bool isTimerRunning = false;

  List<int?> userAnswers = [];
  List<bool?> isCorrect = [];

  Map<int, bool> isFavorite = {};
  Map<int, String> userNotes = {};
  Map<int, bool> expandedImages = {};
  Map<int, bool> expandedAnswers = {};
  TextEditingController noteController = TextEditingController();
  FocusNode noteFocusNode = FocusNode();

  @override
  void initState() {
    userAnswers = List.generate(widget.questions.length, (index) => null);
    isCorrect = List.generate(widget.questions.length, (index) => null);
    super.initState();
  }

  void startTimer() {
    isTimerRunning = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });
  }

  void stopTimer() {
    setState(() {
      isTimerRunning = false;
      timer!.cancel();
    });
  }

  void resetTimer() {
    setState(() {
      seconds = 0;
      isTimerRunning = false;
      timer!.cancel();
    });
  }

  String formatTime() {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void resetAnswers() {
    setState(() {
      correctAnswers = 0;
      wrongAnswers = 0;
      userAnswers = List.generate(widget.questions.length, (index) => null);
      isCorrect = List.generate(widget.questions.length, (index) => null);
    });
  }

  void checkAllAnswers() {
    correctAnswers = 0;
    wrongAnswers = 0;
    setState(() {
      for (int i = 0; i < widget.questions.length; i++) {
        if (widget.questions[i].type == QuestionType.multipleChoice) {
          if (userAnswers[i] == null) {
            isCorrect[i] = false;
            wrongAnswers++;
          } else {
            if (userAnswers[i] == widget.questions[i].correctAnswer) {
              correctAnswers++;
              isCorrect[i] = true;
            } else {
              wrongAnswers++;
              isCorrect[i] = false;
            }
          }
        } else {
          if (userAnswers[i] == null) {
            isCorrect[i] = false;
            wrongAnswers++;
          }
        }
      }
    });
  }

  void checkUserAnswersOnly() {
    setState(() {
      log("${widget.questions.length}");
      for (int i = 0; i < widget.questions.length; i++) {
        if (widget.questions[i].type == QuestionType.multipleChoice) {
          if (userAnswers[i] == null || isCorrect[i] != null) {
            continue;
          } else {
            if (userAnswers[i] == widget.questions[i].correctAnswer) {
              correctAnswers++;
              isCorrect[i] = true;
            } else {
              wrongAnswers++;
              isCorrect[i] = false;
            }
          }
        }
      }
    });
  }

  void checkMultipleChoiceAnswer(int index) {
    setState(() {
      if (userAnswers[index] == null) {
        return;
      } else {
        if (userAnswers[index] == widget.questions[index].correctAnswer) {
          isCorrect[index] = true;
          correctAnswers++;
        } else {
          isCorrect[index] = false;
          wrongAnswers++;
        }
      }
    });
  }

  void checkWrittenAnswer(int index, bool isCorrect) {
    setState(() {
      if (userAnswers[index] == null) {
        userAnswers[index] = 0;
        this.isCorrect[index] = isCorrect;
        isCorrect ? correctAnswers++ : wrongAnswers++;
      } else if (this.isCorrect[index] != isCorrect) {
        userAnswers[index] = 0;
        this.isCorrect[index] = isCorrect;
        isCorrect ? (correctAnswers++, wrongAnswers--) : (wrongAnswers++, correctAnswers--);
      }
    });
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

  void showNoteBottomSheet(BuildContext context, int questionIndex) {
    noteController.text = userNotes[questionIndex] ?? '';

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
                          controller: noteController,
                          focusNode: noteFocusNode,
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
                                if (noteController.text.trim().isNotEmpty) {
                                  this.setState(() {
                                    userNotes[questionIndex] = noteController.text.trim();
                                  });
                                } else {
                                  this.setState(() {
                                    userNotes.remove(questionIndex);
                                  });
                                }
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          if (userNotes.containsKey(questionIndex)) ...[
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
                                  userNotes.remove(questionIndex);
                                  noteController.clear();
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEnhancedStatCard(
                  'Total Questions',
                  widget.questions.length.toString(),
                  Icons.quiz,
                  Color(0xFF84D6FD),
                ),
                _buildEnhancedStatCard(
                  'Correct',
                  correctAnswers.toString(),
                  Icons.check_circle,
                  Color(0xFFA7EF75),
                ),
                _buildEnhancedStatCard(
                  'Wrong',
                  wrongAnswers.toString(),
                  Icons.cancel,
                  Color.fromARGB(255, 254, 117, 117),
                ),
              ],
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onLongPress: () {
              resetTimer();
            },
            child: IconButton(
              icon: const Icon(Icons.timer),
              onPressed: () {
                if (isTimerRunning) {
                  stopTimer();
                } else {
                  startTimer();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                formatTime(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.questions.length,
                  itemBuilder: (context, index) {
                    final question = widget.questions[index];
                    return _buildQuestionCard(question, index);
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

  Widget _buildQuestionCard(Question question, int index) {
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
                        '${index + 1}',
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
                    child: Text(
                      question.text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              if (question.hasImage) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: widget.subjectColor.withOpacity(0.1),
                      ),
                      icon: Icon(
                        expandedImages[index] == true ? Icons.visibility_off : Icons.image,
                        color: widget.subjectColor,
                      ),
                      onPressed: () {
                        setState(() {
                          expandedImages[index] = !(expandedImages[index] ?? false);
                        });
                      },
                    ),
                  ],
                ),
                if (expandedImages[index] == true) ...[
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: question.imageUrl ?? '',
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
                          setState(() {
                            expandedAnswers[index] = !(expandedAnswers[index] ?? false);
                          });
                        },
                        child: Center(
                          child: expandedAnswers[index] == true
                              ? Text(
                                  question.answers[0],
                                )
                              : Icon(
                                  expandedAnswers[index] == true ? Icons.visibility_off : Icons.question_answer_outlined,
                                  color: widget.subjectColor,
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              if (question.type == QuestionType.multipleChoice) _buildMultipleChoiceAnswers(question, index) else _buildAnswer(question, index),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(
                    icon: Icons.lightbulb_outline,
                    color: Color(0xFFFFB347),
                    onPressed: () => showHintBottomSheet(
                      context,
                      question.hint ?? 'No hint available',
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    icon: isFavorite[index] == true ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        isFavorite[index] = !(isFavorite[index] ?? false);
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    icon: userNotes.containsKey(index) ? Icons.note : Icons.note_add,
                    color: widget.subjectColor,
                    onPressed: () => showNoteBottomSheet(context, index),
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
                      onPressed: () => checkMultipleChoiceAnswer(index),
                    ),
                  ] else ...[
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.check,
                      color: Colors.green,
                      onPressed: () => checkWrittenAnswer(index, true),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.close,
                      color: Colors.red,
                      onPressed: () => checkWrittenAnswer(index, false),
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

  Widget _buildAnswer(Question question, int index) {
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

  Widget _buildMultipleChoiceAnswers(Question question, int index) {
    return Column(
      children: question.answers.map((answer) {
        log("${userAnswers[index] ?? "this is null"}");
        bool isSelected = question.answers.indexOf(answer) == userAnswers[index];
        bool isCorrect = question.answers.indexOf(answer) == question.correctAnswer;
        bool isQuestionCorrected = this.isCorrect[index] != null;

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
            ),
            borderRadius: BorderRadius.circular(16),
            onPressed: isQuestionCorrected
                ? null
                : () {
                    setState(() {
                      userAnswers[index] = question.answers.indexOf(answer);
                    });
                  },
            child: Center(
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
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
              onLongPressed: () => showConfirmationDialog('check all answers?', checkAllAnswers),
              onPressed: () => showConfirmationDialog('check your answers?', checkUserAnswersOnly),
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
              onPressed: () => showConfirmationDialog('reset', resetAnswers),
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
    noteController.dispose();
    noteFocusNode.dispose();
    timer?.cancel();
    super.dispose();
  }
}

class Question {
  final String text;
  final QuestionType type;
  final List<String> answers;
  final int correctAnswer;
  final bool hasImage;
  final String? hint;
  final String? imageUrl;

  Question({
    required this.text,
    required this.type,
    this.answers = const [],
    this.correctAnswer = 0,
    this.hasImage = false,
    this.hint,
    this.imageUrl,
  });
}

enum QuestionType { multipleChoice, written }
