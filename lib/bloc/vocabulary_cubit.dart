import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traductao_app/bloc/vocabulary_state.dart';
import 'package:traductao_app/model/vocabulary_entry.dart';
import 'package:traductao_app/model/translation.dart';

class VocabularyCubit extends Cubit<VocabularyState> {
  VocabularyCubit() : super(const VocabularyState());

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
  }

  void addLanguage(VocabularyEntry newEntry) {
    // Vérifier si une langue avec le même nom existe déjà
    final existingLanguage = state.vocabularyEntries
        .where((entry) => entry.language.toLowerCase() == newEntry.language.toLowerCase())
        .isNotEmpty;

    if (existingLanguage) {
      // Vous pourriez émettre un état d'erreur ici si nécessaire
      return;
    }

    final updatedEntries = [...state.vocabularyEntries, newEntry];

    emit(
      state.copyWith(
        status: VocabularyStatus.success,
        vocabularyEntries: updatedEntries,
      ),
    );
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
  }
}
