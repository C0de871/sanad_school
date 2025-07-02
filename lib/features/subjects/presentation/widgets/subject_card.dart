import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sanad_school/core/Routes/app_routes.dart';
import 'package:sanad_school/core/shared/widgets/vibratation_container.dart';
import 'package:sanad_school/features/auth/presentation/widgets/animated_raised_button.dart';

import '../../../../core/theme/theme.dart';
import '../../domain/entities/subject_entity.dart';

class SubjectCard extends StatelessWidget {
  final SubjectEntity subject;
  final bool isExpanded;
  final bool isShrunk;
  final VoidCallback onLongPress;
  final Color placeHolderColor;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.isExpanded,
    required this.isShrunk,
    required this.onLongPress,
    required this.placeHolderColor,
  });

  Color? checkColorNullness(String? colorCode) {
    if (colorCode != null) {
      final int? colorCodeAsInt = int.tryParse(colorCode);
      if (colorCodeAsInt != null) return Color(colorCodeAsInt);
    }
    return null;
  }

  Color? getOnlineSubjectColor(BuildContext context) {
    if (Theme.of(context).colorScheme.brightness == Brightness.light) {
      return checkColorNullness(subject.lightColorCode);
    } else {
      return checkColorNullness(subject.darkColorCode);
    }
  }

  Color getOfflineSubjectColor(BuildContext context) {
    return getOnlineSubjectColor(context) ?? placeHolderColor;
  }

  @override
  Widget build(BuildContext context) {
    return VibrationWidget(
      condition: () => subject.isLocked == 1,
      onTap: () {
        log("tapped");
      },
      child: AnimatedRaisedButtonWithChild(
        padding: EdgeInsets.only(bottom: 8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            getOfflineSubjectColor(context),
            Color.lerp(
                  getOfflineSubjectColor(context),
                  Theme.of(context).colorScheme.scrim,
                  0.2,
                ) ??
                getOfflineSubjectColor(context),
          ],
          stops: const [0.3, 1],
        ),
        borderRadius: BorderRadius.circular(24),
        onLongPressed: onLongPress,
        onPressed: () {
          log("pressed");
          final englishFirstCharRegExp = RegExp(r'^[a-zA-Z]');

          TextDirection direction =
              englishFirstCharRegExp.hasMatch(subject.name)
                  ? TextDirection.ltr
                  : TextDirection.rtl;
          Navigator.pushNamed(
            context,
            AppRoutes.subjectDetails,
            arguments: {
              "subject": subject,
              "color": getOfflineSubjectColor(context),
              "direction": direction,
            },
          );
        },
        child: Column(
          children: [
            Stack(
              children: [
                _DecorativeIcon(subject: subject),
                _SubjectContent(
                  subject: subject,
                  isExpanded: isExpanded,
                  isShrunk: isShrunk,
                ),
                // const _ProgressIndicator(),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: SizedBox(
                  height: isExpanded ? null : 0,
                  child: Column(
                    children: [
                      Divider(
                        color: AppTheme.extendedColorOf(context).white,
                        thickness: 3,
                        // indent: 20,
                        // endIndent: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "عدد الأسئلة: ${subject.numberOfQuestions}",
                                style: TextStyle(
                                  color:
                                      AppTheme.extendedColorOf(context).white,
                                  fontSize: 14,
                                  height: 1.6,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Text(
                                "عدد الدورات: ${subject.numberOfExams}",
                                style: TextStyle(
                                  color:
                                      AppTheme.extendedColorOf(context).white,
                                  fontSize: 14,
                                  height: 1.6,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Text(
                                "عدد الدروس: ${subject.numberOfLessons}",
                                style: TextStyle(
                                  color:
                                      AppTheme.extendedColorOf(context).white,
                                  fontSize: 14,
                                  height: 1.6,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "عدد التصنيفات: ${subject.numberOfTags}",
                                style: TextStyle(
                                  color:
                                      AppTheme.extendedColorOf(context).white,
                                  fontSize: 14,
                                  height: 1.6,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Text(
                                "الأستاذ: ${subject.teacher}",
                                style: TextStyle(
                                  color:
                                      AppTheme.extendedColorOf(context).white,
                                  fontSize: 14,
                                  height: 1.6,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget to display the large, decorative background icon.
class _DecorativeIcon extends StatelessWidget {
  final SubjectEntity subject;

  const _DecorativeIcon({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: -30,
      top: -30,
      child: Transform.rotate(
        angle: 0.2,
        // child: Icon(
        //   // getIconByName(subject.icon),
        //   // Icons.abc,
        //   size: 140,
        //   color:
        //       AppTheme.extendedColorOf(context).white.withValues(alpha: 0.05),
        // ),
        child: Image.asset(
          "assets/icons/calcuator.png",
          colorBlendMode: BlendMode.srcIn,
          color: AppTheme.extendedColorOf(
            context,
          ).white.withValues(alpha: 0.05),
        ),
      ),
    );
  }
}

/// The main content of the card which arranges the icon/title and,
/// optionally, the description section.
class _SubjectContent extends StatelessWidget {
  final SubjectEntity subject;
  final bool isExpanded;
  final bool isShrunk;

  const _SubjectContent({
    required this.subject,
    required this.isExpanded,
    required this.isShrunk,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20, // 16
        vertical: 16,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _IconTitleSection(subject: subject, isShrunk: isShrunk),
          ),
          Expanded(flex: 3, child: _DescriptionSection(subject: subject)),
        ],
      ),
    );
  }
}

/// Displays the subject icon inside an animated container and
/// the subject title using an animated text style.
class _IconTitleSection extends StatelessWidget {
  final SubjectEntity subject;
  final bool isShrunk;

  const _IconTitleSection({required this.subject, required this.isShrunk});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _subjectIcon(context, subject.icon),
        const SizedBox(height: 16),
        _subjectTitle(context),
      ],
    );
  }

  AnimatedDefaultTextStyle _subjectTitle(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppTheme.extendedColorOf(context).white,
        height: 1.2,
      ),
      textAlign: TextAlign.center,
      child: Text(subject.name),
    );
  }

  AnimatedContainer _subjectIcon(BuildContext context, String icon) {
    // log("icon code:${int.parse(subject.iconCodePoint, radix: 16)}");
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(16), // 8
      decoration: BoxDecoration(
        color: AppTheme.extendedColorOf(context).white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.extendedColorOf(context).white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Image.asset(
        "assets/icons/calcuator.png",
        colorBlendMode: BlendMode.srcIn,
        height: 48,
        width: 48,
        color: AppTheme.extendedColorOf(context).white,
      ),
    );
  }
}

/// Displays the subject description along with a "Learn More" button.
/// This widget is only visible when the card is expanded.
class _DescriptionSection extends StatelessWidget {
  final SubjectEntity subject;

  const _DescriptionSection({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          constraints: const BoxConstraints(maxHeight: 130),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.extendedColorOf(
              context,
            ).white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.extendedColorOf(
                context,
              ).white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  subject.description,
                  style: TextStyle(
                    color: AppTheme.extendedColorOf(context).white,
                    fontSize: 14,
                    height: 1.6,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Displays a circular progress indicator at the bottom-right of the card.
class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 12,
      right: 12,
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.extendedColorOf(
            context,
          ).white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.extendedColorOf(
              context,
            ).white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: CircularProgressIndicator(
          value: 0.7,
          strokeWidth: 2,
          backgroundColor: AppTheme.extendedColorOf(
            context,
          ).white.withValues(alpha: 0.1),
          color: AppTheme.extendedColorOf(context).white,
        ),
      ),
    );
  }
}
