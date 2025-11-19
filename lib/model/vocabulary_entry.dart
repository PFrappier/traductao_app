import 'package:traductao_app/model/translation.dart';
import 'package:traductao_app/model/translation_pack.dart';

class VocabularyEntry {
  final String id;
  final String language;
  final String countryCode;
  final List<TranslationGroup> groups;

  VocabularyEntry({
    required this.id,
    required this.language,
    required this.countryCode,
    required this.groups,
  });

  // Helper getters
  List<Translation> get translations =>
      groups.expand((group) => group.translations).toList();

  int get totalTranslations => translations.length;

  int get acquiredGroupsCount =>
      groups.where((group) => group.isAcquired).length;

  int get totalGroups => groups.length;

  // Alias pour rétrocompatibilité
  List<TranslationGroup> get packs => groups;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'language': language,
      'countryCode': countryCode,
      'groups': groups.map((g) => g.toJson()).toList(),
    };
  }

  factory VocabularyEntry.fromJson(Map<String, dynamic> json) {
    // Support pour l'ancien format avec 'translations' (sans groupes)
    if (json.containsKey('translations') && !json.containsKey('packs') && !json.containsKey('groups')) {
      final translations = (json['translations'] as List)
          .map((t) => Translation.fromJson(t as Map<String, dynamic>))
          .toList();

      // Mettre toutes les traductions dans un groupe par défaut
      final groups = translations.isEmpty
          ? <TranslationGroup>[]
          : [
              TranslationGroup(
                id: '${json['id']}_default',
                name: 'Non groupé',
                translations: translations,
              ),
            ];

      return VocabularyEntry(
        id: json['id'] as String,
        language: json['language'] as String,
        countryCode: json['countryCode'] as String,
        groups: groups,
      );
    }

    // Support pour le format avec 'packs'
    if (json.containsKey('packs') && !json.containsKey('groups')) {
      return VocabularyEntry(
        id: json['id'] as String,
        language: json['language'] as String,
        countryCode: json['countryCode'] as String,
        groups: (json['packs'] as List)
            .map((p) => TranslationGroup.fromJson(p as Map<String, dynamic>))
            .toList(),
      );
    }

    // Nouveau format avec groups
    return VocabularyEntry(
      id: json['id'] as String,
      language: json['language'] as String,
      countryCode: json['countryCode'] as String,
      groups: (json['groups'] as List)
          .map((g) => TranslationGroup.fromJson(g as Map<String, dynamic>))
          .toList(),
    );
  }
}