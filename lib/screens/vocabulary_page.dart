import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traductao_app/bloc/vocabulary_cubit.dart';
import 'package:traductao_app/bloc/vocabulary_state.dart';
import 'package:traductao_app/model/vocabulary_entry.dart';
import 'package:traductao_app/model/translation.dart';
import 'package:traductao_app/widgets/language_card.dart';
import 'package:traductao_app/widgets/edit_language_dialog.dart';
import 'package:traductao_app/widgets/add_language_dialog.dart';

class MyVocabularyPage extends StatefulWidget {
  const MyVocabularyPage({super.key});

  @override
  State<MyVocabularyPage> createState() => _MyVocabularyPageState();
}

class _MyVocabularyPageState extends State<MyVocabularyPage> {
  @override
  void initState() {
    super.initState();
    // Initialiser avec des données de test si la liste est vide
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<VocabularyCubit>();
      if (cubit.vocabularyEntries.isEmpty) {
        _initializeTestData(cubit);
      }
    });
  }

  void _initializeTestData(VocabularyCubit cubit) {
    final testEntries = [
      VocabularyEntry(
        id: '1',
        language: 'Espagnol',
        countryCode: 'es',
        translations: List.generate(
          10,
          (index) => Translation(
            id: 'es_$index',
            text: 'Test $index',
            translatedText: 'Prueba $index',
          ),
        ),
      ),
      VocabularyEntry(
        id: '2',
        language: 'Anglais',
        countryCode: 'gb',
        translations: List.generate(
          13,
          (index) => Translation(
            id: 'en_$index',
            text: 'Test $index',
            translatedText: 'Test $index',
          ),
        ),
      ),
    ];

    for (var entry in testEntries) {
      cubit.updateLanguage(entry);
    }
  }

  void _handleEdit(VocabularyEntry entry) async {
    final result = await showDialog<VocabularyEntry>(
      context: context,
      builder: (context) => EditLanguageDialog(entry: entry),
    );

    if (result != null && mounted) {
      context.read<VocabularyCubit>().updateLanguage(result);
    }
  }

  void _handleDelete(VocabularyEntry entry) {
    context.read<VocabularyCubit>().deleteLanguage(entry.id);
  }

  void _handleAdd() async {
    final result = await showDialog<VocabularyEntry>(
      context: context,
      builder: (context) => const AddLanguageDialog(),
    );

    if (result != null && mounted) {
      context.read<VocabularyCubit>().addLanguage(result);

      // Afficher un message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${result.language} ajouté avec succès !'),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon vocabulaire'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<VocabularyCubit, VocabularyState>(
          builder: (context, state) {
            if (state.vocabularyEntries.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.language,
                      size: 80,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Aucune langue dans ton vocabulaire',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Appuie sur + pour ajouter ta première langue',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                const double spacing = 8.0;
                final double availableWidth = constraints.maxWidth;
                final int cardsPerRow =
                    (availableWidth + spacing) ~/ (150 + spacing);
                final double cardWidth =
                    (availableWidth - (cardsPerRow - 1) * spacing) /
                    cardsPerRow;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: state.vocabularyEntries.map((entry) {
                    return LanguageCard(
                      entry: entry,
                      width: cardWidth,
                      onEdit: () => _handleEdit(entry),
                      onDelete: () => _handleDelete(entry),
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleAdd,
        tooltip: 'Ajouter une langue',
        child: const Icon(Icons.add),
      ),
    );
  }
}
