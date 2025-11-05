import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traductao_app/bloc/vocabulary_state.dart';
import 'package:traductao_app/model/vocabulary_entry.dart';
import 'package:traductao_app/model/translation.dart';

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
      print('Erreur lors de la sauvegarde: $e');
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
      print('Erreur lors du chargement: $e');
      emit(state.copyWith(
        status: VocabularyStatus.failure,
        vocabularyEntries: [],
      ));
    }
  }

  List<VocabularyEntry> get vocabularyEntries => state.vocabularyEntries;

  void deleteTranslations(List<String> translationIds) {
    final updatedEntries = state.vocabularyEntries.map((entry) {
      final updatedTranslations = entry.translations
          .where((translation) => !translationIds.contains(translation.id))
          .toList();
      return VocabularyEntry(
        id: entry.id,
        language: entry.language,
        countryCode: entry.countryCode,
        translations: updatedTranslations,
      );
    }).toList();

    emit(
      state.copyWith(
        status: VocabularyStatus.success,
        vocabularyEntries: updatedEntries,
      ),
    );
    _saveVocabulary();
  }

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

  void addTranslation(String languageId, Translation newTranslation) {
    final updatedEntries = state.vocabularyEntries.map((entry) {
      if (entry.id == languageId) {
        return VocabularyEntry(
          id: entry.id,
          language: entry.language,
          countryCode: entry.countryCode,
          translations: [...entry.translations, newTranslation],
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

  void updateTranslation(String languageId, Translation updatedTranslation) {
    final updatedEntries = state.vocabularyEntries.map((entry) {
      if (entry.id == languageId) {
        final updatedTranslations = entry.translations.map((translation) {
          if (translation.id == updatedTranslation.id) {
            return updatedTranslation;
          }
          return translation;
        }).toList();

        return VocabularyEntry(
          id: entry.id,
          language: entry.language,
          countryCode: entry.countryCode,
          translations: updatedTranslations,
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

  void toggleQuizInclusion(String languageId, String translationId) {
    final updatedEntries = state.vocabularyEntries.map((entry) {
      if (entry.id == languageId) {
        final updatedTranslations = entry.translations.map((translation) {
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

        return VocabularyEntry(
          id: entry.id,
          language: entry.language,
          countryCode: entry.countryCode,
          translations: updatedTranslations,
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
