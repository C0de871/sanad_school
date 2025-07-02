import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sanad_school/features/questions/enums/question_type_enum.dart';
import 'package:sanad_school/features/questions/presentation/cubit/question_cubit.dart';
import 'package:sanad_school/features/questions/presentation/cubit/question_state.dart';
import 'package:sanad_school/features/questions/presentation/widgets/timer_button.dart';
import 'package:sanad_school/features/questions/presentation/widgets/timer_display.dart';
import 'package:secure_application/secure_application.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import '../../../core/shared/widgets/animated_loading_screen.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/constants/app_numbers.dart';
import '../../../core/utils/constants/constant.dart';
import '../../auth/presentation/widgets/animated_raised_button.dart';
import '../domain/entities/question_entity.dart';

part 'dialog/questions_screen_dialog_manager.dart';
part 'widgets/state_card.dart';
part 'widgets/bottom_action_bar.dart';
part 'widgets/bottom_action_button.dart';
part 'widgets/multiple_choice_answers.dart';
part 'widgets/questoin_card.dart';
part 'widgets/fallback_embed_builder.dart';
part 'widgets/formula_embed_builder.dart';
part 'widgets/reset_answers_button.dart';
part 'widgets/check_answers_button.dart';
part 'widgets/my_quill_editor.dart';
part 'dialog/confirm_dialog.dart';
part 'dialog/questions_success_dialog.dart';
part 'dialog/note_bottom_sheet.dart';
part 'dialog/hint_bottom_sheet.dart';
part 'dialog/report_bottom_sheet.dart';
part "questions_body.dart";
part "questions_app_bar.dart";


class QuestionsPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SecureApplication(
      nativeRemoveDelay: 100,
      onNeedUnlock: (secureApplicationController) async {
        return SecureApplicationAuthenticationStatus.SUCCESS;
      },
      child: SecureGate(
        blurr: 20,
        opacity: 0.6,
        child: Directionality(
          textDirection: textDirection,
          child: Scaffold(
            appBar: _QuestionAppBar(lessonName: lessonName),
            body: _QuestionBody(subjectColor: subjectColor),
          ),
        ),
      ),
    );
  }
}
