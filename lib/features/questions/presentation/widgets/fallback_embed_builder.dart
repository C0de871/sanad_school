part of "../questions_screen.dart";


class FallbackEmbedBuilder extends EmbedBuilder {
  // A unique key for this builder
  @override
  String get key => 'fallback';

  @override
  bool get expanded => false;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    log('Skipping unhandled embed type: ${embedContext.node.value.type}');

    return SizedBox(width: 0, height: 0);
  }
}
