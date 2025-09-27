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
}