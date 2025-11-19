import 'package:traductao_app/model/translation.dart';

class TranslationGroup {
  final String id;
  final String name;
  final List<Translation> translations;
  final bool isAcquired;
  final DateTime? acquiredDate;
  final String? description;

  TranslationGroup({
    required this.id,
    required this.name,
    required this.translations,
    this.isAcquired = false,
    this.acquiredDate,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'translations': translations.map((t) => t.toJson()).toList(),
      'isAcquired': isAcquired,
      'acquiredDate': acquiredDate?.toIso8601String(),
      'description': description,
    };
  }

  factory TranslationGroup.fromJson(Map<String, dynamic> json) {
    // Migration depuis l'ancien format TranslationPack
    if (json.containsKey('packNumber') && !json.containsKey('name')) {
      final packNumber = json['packNumber'] as int;
      return TranslationGroup(
        id: json['id'] as String,
        name: 'Paquet $packNumber',
        translations: (json['translations'] as List)
            .map((t) => Translation.fromJson(t as Map<String, dynamic>))
            .toList(),
        isAcquired: json['isAcquired'] as bool? ?? false,
        acquiredDate: json['acquiredDate'] != null
            ? DateTime.parse(json['acquiredDate'] as String)
            : null,
      );
    }

    // Nouveau format
    return TranslationGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      translations: (json['translations'] as List)
          .map((t) => Translation.fromJson(t as Map<String, dynamic>))
          .toList(),
      isAcquired: json['isAcquired'] as bool? ?? false,
      acquiredDate: json['acquiredDate'] != null
          ? DateTime.parse(json['acquiredDate'] as String)
          : null,
      description: json['description'] as String?,
    );
  }

  TranslationGroup copyWith({
    String? id,
    String? name,
    List<Translation>? translations,
    bool? isAcquired,
    DateTime? acquiredDate,
    String? description,
  }) {
    return TranslationGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      translations: translations ?? this.translations,
      isAcquired: isAcquired ?? this.isAcquired,
      acquiredDate: acquiredDate ?? this.acquiredDate,
      description: description ?? this.description,
    );
  }
}

// Alias pour compatibilité
typedef TranslationPack = TranslationGroup;
