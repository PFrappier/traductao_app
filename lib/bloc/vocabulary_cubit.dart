import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traductao_app/bloc/vocabulary_state.dart';
import 'package:traductao_app/model/vocabulary_entry.dart';
import 'package:traductao_app/model/translation.dart';
import 'package:traductao_app/model/translation_pack.dart';

class VocabularyCubit extends Cubit<VocabularyState> {
  static const String _vocabularyKey = 'vocabulary_entries';

  VocabularyCubit() : super(const VocabularyState()) {
    loadVocabulary();
  }

  Future<void> _saveVocabulary() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = state.vocabularyEntries.map((e) => e.toJson()).toList();
      await prefs.setString(_vocabularyKey, jsonEncode(jsonList));
    } catch (e) {
      // Erreur lors de la sauvegarde
    }
  }

  String exportVocabulary() {
    final jsonList = state.vocabularyEntries.map((e) => e.toJson()).toList();
    return jsonEncode(jsonList);
  }

  Future<bool> importVocabulary(String jsonString) async {
    try {
      final jsonList = jsonDecode(jsonString) as List;
      final entries = jsonList
          .map((e) => VocabularyEntry.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(state.copyWith(
        status: VocabularyStatus.success,
        vocabularyEntries: entries,
      ));

      await _saveVocabulary();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> loadVocabulary() async {
    emit(state.copyWith(status: VocabularyStatus.loading));

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_vocabularyKey);

      if (jsonString == null || jsonString.isEmpty) {
        emit(state.copyWith(
          status: VocabularyStatus.success,
          vocabularyEntries: [],
        ));
        return;
      }

      final jsonList = jsonDecode(jsonString) as List;
      final entries = jsonList
          .map((e) => VocabularyEntry.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(state.copyWith(
        status: VocabularyStatus.success,
        vocabularyEntries: entries,
      ));
    } catch (e) {
      // Erreur lors du chargement
      emit(state.copyWith(
        status: VocabularyStatus.failure,
        vocabularyEntries: [],
      ));
    }
  }

  List<VocabularyEntry> get vocabularyEntries => state.vocabularyEntries;

  // === Gestion des langues ===

  void deleteLanguage(String languageId) {
    final updatedEntries = state.vocabularyEntries
        .where((entry) => entry.id != languageId)
        .toList();

    emit(
      state.copyWith(
        status: VocabularyStatus.success,
        vocabularyEntries: updatedEntries,
      ),
    );
    _saveVocabulary();
  }

  void updateLanguage(VocabularyEntry updatedEntry) {
    final updatedEntries = state.vocabularyEntries.map((entry) {
      if (entry.id == updatedEntry.id) {
        return updatedEntry;
      }
      return entry;
    }).toList();

    emit(
      state.copyWith(
        status: VocabularyStatus.success,
        vocabularyEntries: updatedEntries,
      ),
    );
    _saveVocabulary();
  }

  void addLanguage(VocabularyEntry newEntry) {
    final existingLanguage = state.vocabularyEntries
        .where((entry) => entry.language.toLowerCase() == newEntry.language.toLowerCase())
        .isNotEmpty;

    if (existingLanguage) {
      return;
    }

    final updatedEntries = [...state.vocabularyEntries, newEntry];

    emit(
      state.copyWith(
        status: VocabularyStatus.success,
        vocabularyEntries: updatedEntries,
      ),
    );
    _saveVocabulary();
  }

  bool languageExists(String languageName) {
    return state.vocabularyEntries
        .any((entry) => entry.language.toLowerCase() == languageName.toLowerCase());
  }

  // === Gestion des groupes ===

  void addGroup(String languageId, TranslationGroup newGroup) {
    final updatedEntries = state.vocabularyEntries.map((entry) {
      if (entry.id == languageId) {
        return VocabularyEntry(
          id: entry.id,
          language: entry.language,
          countryCode: entry.countryCode,
          groups: [...entry.groups, newGroup],
        );
      }
      return entry;
    }).toList();

    emit(
      state.copyWith(
        status: VocabularyStatus.success,
        vocabularyEntries: updatedEntries,
      ),
    );
    _saveVocabulary();
  }

  void updateGroup(String languageId, TranslationGroup updatedGroup) {
    final updatedEntries = state.vocabularyEntries.map((entry) {
      if (entry.id == languageId) {
        final updatedGroups = entry.groups.map((group) {
          if (group.id == updatedGroup.id) {
            return updatedGroup;
          }
          return group;
        }).toList();

        return VocabularyEntry(
          id: entry.id,
          language: entry.language,
          countryCode: entry.countryCode,
          groups: updatedGroups,
        );
      }
      return entry;
    }).toList();

    emit(
      state.copyWith(
        status: VocabularyStatus.success,
        vocabularyEntries: updatedEntries,
      ),
    );
    _saveVocabulary();
  }

  void deleteGroup(String languageId, String groupId) {
    final updatedEntries = state.vocabularyEntries.map((entry) {
      if (entry.id == languageId) {
        final updatedGroups = entry.groups
            .where((group) => group.id != groupId)
            .toList();

        return VocabularyEntry(
          id: entry.id,
          language: entry.language,
          countryCode: entry.countryCode,
          groups: updatedGroups,
        );
      }
      return entry;
    }).toList();

    emit(
      state.copyWith(
        status: VocabularyStatus.success,
        vocabularyEntries: updatedEntries,
      ),
    );
    _saveVocabulary();
  }

  void deleteGroups(String languageId, List<String> groupIds) {
    final updatedEntries = state.vocabularyEntries.map((entry) {
      if (entry.id == languageId) {
        final updatedGroups = entry.groups
            .where((group) => !groupIds.contains(group.id))
            .toList();

        return VocabularyEntry(
          id: entry.id,
          language: entry.language,
          countryCode: entry.countryCode,
          groups: updatedGroups,
        );
      }
      return entry;
    }).toList();

    emit(
      state.copyWith(
        status: VocabularyStatus.success,
        vocabularyEntries: updatedEntries,
      ),
    );
    _saveVocabulary();
  }

  void toggleGroupAcquired(String languageId, String groupId) {
    final updatedEntries = state.vocabularyEntries.map((entry) {
      if (entry.id == languageId) {
        final updatedGroups = entry.groups.map((group) {
          if (group.id == groupId) {
            return group.copyWith(
              isAcquired: !group.isAcquired,
              acquiredDate: !group.isAcquired ? DateTime.now() : null,
            );
          }
          return group;
        }).toList();

        return VocabularyEntry(
          id: entry.id,
          language: entry.language,
          countryCode: entry.countryCode,
          groups: updatedGroups,
        );
      }
      return entry;
    }).toList();

    emit(
      state.copyWith(
        status: VocabularyStatus.success,
        vocabularyEntries: updatedEntries,
      ),
    );
    _saveVocabulary();
  }

  TranslationGroup? getGroupById(String languageId, String groupId) {
    final entry = state.vocabularyEntries.firstWhere(
      (e) => e.id == languageId,
      orElse: () => VocabularyEntry(
        id: '',
        language: '',
        countryCode: '',
        groups: [],
      ),
    );

    if (entry.id.isEmpty) return null;

    try {
      return entry.groups.firstWhere((group) => group.id == groupId);
    } catch (e) {
      return null;
    }
  }

  // === Gestion des traductions ===

  void addTranslation(String languageId, String groupId, Translation newTranslation) {
    final updatedEntries = state.vocabularyEntries.map((entry) {
      if (entry.id == languageId) {
        final updatedGroups = entry.groups.map((group) {
          if (group.id == groupId) {
            return TranslationGroup(
              id: group.id,
              name: group.name,
              translations: [...group.translations, newTranslation],
              isAcquired: group.isAcquired,
              acquiredDate: group.acquiredDate,
              description: group.description,
            );
          }
          return group;
        }).toList();

        return VocabularyEntry(
          id: entry.id,
          language: entry.language,
          countryCode: entry.countryCode,
          groups: updatedGroups,
        );
      }
      return entry;
    }).toList();

    emit(
      state.copyWith(
        status: VocabularyStatus.success,
        vocabularyEntries: updatedEntries,
      ),
    );
    _saveVocabulary();
  }

  void updateTranslation(String languageId, String groupId, Translation updatedTranslation) {
    final updatedEntries = state.vocabularyEntries.map((entry) {
      if (entry.id == languageId) {
        final updatedGroups = entry.groups.map((group) {
          if (group.id == groupId) {
            final updatedTranslations = group.translations.map((translation) {
              if (translation.id == updatedTranslation.id) {
                return updatedTranslation;
              }
              return translation;
            }).toList();

            return TranslationGroup(
              id: group.id,
              name: group.name,
              translations: updatedTranslations,
              isAcquired: group.isAcquired,
              acquiredDate: group.acquiredDate,
              description: group.description,
            );
          }
          return group;
        }).toList();

        return VocabularyEntry(
          id: entry.id,
          language: entry.language,
          countryCode: entry.countryCode,
          groups: updatedGroups,
        );
      }
      return entry;
    }).toList();

    emit(
      state.copyWith(
        status: VocabularyStatus.success,
        vocabularyEntries: updatedEntries,
      ),
    );
    _saveVocabulary();
  }

  void deleteTranslations(String languageId, String groupId, List<String> translationIds) {
    final updatedEntries = state.vocabularyEntries.map((entry) {
      if (entry.id == languageId) {
        final updatedGroups = entry.groups.map((group) {
          if (group.id == groupId) {
            final updatedTranslations = group.translations
                .where((translation) => !translationIds.contains(translation.id))
                .toList();
            return TranslationGroup(
              id: group.id,
              name: group.name,
              translations: updatedTranslations,
              isAcquired: group.isAcquired,
              acquiredDate: group.acquiredDate,
              description: group.description,
            );
          }
          return group;
        }).toList();

        return VocabularyEntry(
          id: entry.id,
          language: entry.language,
          countryCode: entry.countryCode,
          groups: updatedGroups,
        );
      }
      return entry;
    }).toList();

    emit(
      state.copyWith(
        status: VocabularyStatus.success,
        vocabularyEntries: updatedEntries,
      ),
    );
    _saveVocabulary();
  }

  void toggleQuizInclusion(String languageId, String groupId, String translationId) {
    final updatedEntries = state.vocabularyEntries.map((entry) {
      if (entry.id == languageId) {
        final updatedGroups = entry.groups.map((group) {
          if (group.id == groupId) {
            final updatedTranslations = group.translations.map((translation) {
              if (translation.id == translationId) {
                return Translation(
                  id: translation.id,
                  text: translation.text,
                  translatedText: translation.translatedText,
                  includeInQuiz: !translation.includeInQuiz,
                );
              }
              return translation;
            }).toList();

            return TranslationGroup(
              id: group.id,
              name: group.name,
              translations: updatedTranslations,
              isAcquired: group.isAcquired,
              acquiredDate: group.acquiredDate,
              description: group.description,
            );
          }
          return group;
        }).toList();

        return VocabularyEntry(
          id: entry.id,
          language: entry.language,
          countryCode: entry.countryCode,
          groups: updatedGroups,
        );
      }
      return entry;
    }).toList();

    emit(
      state.copyWith(
        status: VocabularyStatus.success,
        vocabularyEntries: updatedEntries,
      ),
    );
    _saveVocabulary();
  }
}
