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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'translatedText': translatedText,
      'includeInQuiz': includeInQuiz,
    };
  }

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      id: json['id'] as String,
      text: json['text'] as String,
      translatedText: json['translatedText'] as String,
      includeInQuiz: json['includeInQuiz'] as bool? ?? true,
    );
  }
}