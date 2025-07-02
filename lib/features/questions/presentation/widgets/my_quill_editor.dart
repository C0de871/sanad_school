part of "../questions_screen.dart";

class MyQuillEditor extends StatelessWidget {
  const MyQuillEditor({
    super.key,
    this.textColor,
    required this.focusNode,
    required this.controller,
    required this.scrollController,
  });

  final Color? textColor;
  final FocusNode focusNode;
  final QuillController controller;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final questionCubit = context.read<QuestionCubit>();
    return _buildQuillEditor(questionCubit, textColor);
  }

  Widget _buildQuillEditor(QuestionCubit questionCubit, Color? textColor) {
    return QuillEditor(
      focusNode: focusNode,
      controller: controller,
      scrollController: scrollController,
      config: _buildQuillEditorConfig(textColor),
    );
  }

  QuillEditorConfig _buildQuillEditorConfig(Color? textColor) {
    return QuillEditorConfig(
      customStyles: _buildCustomStyles(textColor),
      customStyleBuilder: (_) => TextStyle(color: textColor),
      scrollable: false,
      requestKeyboardFocusOnCheckListChanged: false,
      showCursor: false,
      autoFocus: false,
      padding: EdgeInsets.zero,
      enableInteractiveSelection: false,
      unknownEmbedBuilder: FallbackEmbedBuilder(),
      embedBuilders: [FormulaEmbedBuilder(textColor)],
    );
  }

  DefaultStyles _buildCustomStyles(Color? textColor) {
    const noSpacing = HorizontalSpacing(0, 0);
    const noVerticalSpacing = VerticalSpacing(0, 0);

    final textStyle = TextStyle(color: textColor, fontSize: 16);
    final blockStyle = DefaultTextBlockStyle(
      textStyle,
      noSpacing,
      noVerticalSpacing,
      noVerticalSpacing,
      null,
    );

    return DefaultStyles(
      color: textColor,
      paragraph: blockStyle,
      h1: blockStyle,
    );
  }
}
