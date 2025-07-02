part of "../questions_screen.dart";


class FormulaEmbedBuilder extends EmbedBuilder {
  FormulaEmbedBuilder([this.color]);

  Color? color;
  @override
  String get key => 'formula';

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
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
