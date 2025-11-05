import 'package:traductao_app/model/translation.dart';

class VocabularyEntry {
  final String id;
  final String language;
  final String countryCode;
  final List<Translation> translations;

  VocabularyEntry({
    required this.id,
    required this.language,
    required this.countryCode,
    required this.translations,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'language': language,
      'countryCode': countryCode,
      'translations': translations.map((t) => t.toJson()).toList(),
    };
  }

  factory VocabularyEntry.fromJson(Map<String, dynamic> json) {
    return VocabularyEntry(
      id: json['id'] as String,
      language: json['language'] as String,
      countryCode: json['countryCode'] as String,
      translations: (json['translations'] as List)
          .map((t) => Translation.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }
}