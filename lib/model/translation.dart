class Translation {
  final String id;
  final String text;
  final String translatedText;
  final bool includeInQuiz;

  Translation({
    required this.id,
    required this.text,
    required this.translatedText,
    this.includeInQuiz = true,
  });
}