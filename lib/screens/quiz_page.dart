import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:traductao_app/bloc/vocabulary_cubit.dart';
import 'package:traductao_app/bloc/vocabulary_state.dart';
import 'package:traductao_app/model/translation.dart';
import 'package:traductao_app/providers/navbar_provider.dart';
import 'package:traductao_app/widgets/text_button_with_icon.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String? _selectedLanguage;
  String? _selectedLanguageId;
  String? _selectedGroupId;
  String? _languageError;
  String? _groupError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Quiz'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<VocabularyCubit, VocabularyState>(
          builder: (context, state) {
            if (state.vocabularyEntries.isEmpty) {
              return _buildEmptyState(context);
            }

            return _buildQuizForm(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 24),
          Text(
            'Aucun quiz disponible',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            'Pour créer un quiz, tu dois d\'abord ajouter une langue à ton vocabulaire.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () {
              context.read<NavBarProvider>().setCurrentIndex(0);
              context.go('/my_vocabulary');
            },
            child: const Text('Aller au vocabulaire'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizForm(BuildContext context, VocabularyState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Teste tes connaissances 🤔",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        Text(
          "Lance un quiz en choisissant la langue et le groupe de traductions.",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 30),
        DropdownMenu<String>(
          label: const Text("Langue"),
          width: double.infinity,
          errorText: _languageError,
          onSelected: (String? value) {
            setState(() {
              _selectedLanguage = value;
              _selectedLanguageId = state.vocabularyEntries
                  .firstWhere((e) => e.language == value)
                  .id;
              _selectedGroupId = null; // Reset group selection
              _languageError = null;
              _groupError = null;
            });
          },
          dropdownMenuEntries: state.vocabularyEntries
              .map(
                (entry) => DropdownMenuEntry(
                  value: entry.language,
                  label: entry.language,
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
        DropdownMenu<String>(
          label: const Text("Groupe"),
          width: double.infinity,
          enabled: _selectedLanguage != null,
          errorText: _groupError,
          onSelected: (String? value) {
            setState(() {
              _selectedGroupId = value;
              _groupError = null;
            });
          },
          dropdownMenuEntries: _selectedLanguage == null
              ? []
              : [
                  const DropdownMenuEntry(
                    value: 'all',
                    label: 'Tous les groupes',
                  ),
                  ...state.vocabularyEntries
                      .firstWhere((e) => e.id == _selectedLanguageId)
                      .groups
                      .map(
                        (group) => DropdownMenuEntry(
                          value: group.id,
                          label: group.name,
                        ),
                      ),
                ],
        ),
        const Spacer(),
        TextButtonWithIcon(
          text: "Lancer le quiz",
          icon: const Icon(Icons.play_arrow),
          outlined: false,
          onPressed: () => _launchQuiz(context, state),
        ),
      ],
    );
  }

  void _launchQuiz(BuildContext context, VocabularyState state) {
    if (_selectedLanguage == null) {
      setState(() {
        _languageError = 'Veuillez sélectionner une langue';
      });
      return;
    }

    if (_selectedGroupId == null) {
      setState(() {
        _groupError = 'Veuillez sélectionner un groupe';
      });
      return;
    }

    final selectedEntry = state.vocabularyEntries.firstWhere(
      (entry) => entry.language == _selectedLanguage,
    );

    List<Translation> visibleTranslations;

    if (_selectedGroupId == 'all') {
      // Toutes les traductions de la langue
      visibleTranslations = selectedEntry.translations
          .where((translation) => translation.includeInQuiz)
          .toList();
    } else {
      // Traductions d'un groupe spécifique
      final selectedGroup = selectedEntry.groups.firstWhere(
        (group) => group.id == _selectedGroupId,
      );
      visibleTranslations = selectedGroup.translations
          .where((translation) => translation.includeInQuiz)
          .toList();
    }

    if (visibleTranslations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune traduction visible disponible pour cette langue'),
        ),
      );
      return;
    }

    final quizTranslations = visibleTranslations.toList()..shuffle(Random());

    context.push(
      '/quiz/session/${Uri.encodeComponent(_selectedLanguage!)}',
      extra: quizTranslations,
    );
  }
}
