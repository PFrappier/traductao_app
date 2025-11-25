import 'dart:convert';
import 'dart:html' as html;
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
    // Données de test désactivées - l'utilisateur peut ajouter ses propres langues
    // Si vous souhaitez réactiver les données de test, décommentez le code ci-dessous

    /*
    final testTranslations = List.generate(
      10,
      (index) => Translation(
        id: 'es_$index',
        text: 'Test $index',
        translatedText: 'Prueba $index',
      ),
    );

    final testPacks = <TranslationPack>[];
    for (var i = 0; i < testTranslations.length; i += 20) {
      final packTranslations = testTranslations.skip(i).take(20).toList();
      testPacks.add(TranslationPack(
        id: '1_pack_${(i ~/ 20) + 1}',
        packNumber: (i ~/ 20) + 1,
        translations: packTranslations,
      ));
    }

    final testEntries = [
      VocabularyEntry(
        id: '1',
        language: 'Espagnol',
        countryCode: 'es',
        packs: testPacks,
      ),
    ];

    for (var entry in testEntries) {
      cubit.updateLanguage(entry);
    }
    */
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
          backgroundColor: Theme.of(context).colorScheme.secondary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleExport() {
    final cubit = context.read<VocabularyCubit>();
    final jsonString = cubit.exportVocabulary();

    // Créer un blob et télécharger le fichier
    final bytes = utf8.encode(jsonString);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'vocabulaire_${DateTime.now().millisecondsSinceEpoch}.json')
      ..click();
    html.Url.revokeObjectUrl(url);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vocabulaire exporté avec succès !'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleImport() async {
    try {
      // Créer un input file HTML
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = '.json';
      uploadInput.click();

      // Attendre que l'utilisateur sélectionne un fichier
      await uploadInput.onChange.first;

      final files = uploadInput.files;
      if (files == null || files.isEmpty) {
        return;
      }

      final file = files[0];
      final reader = html.FileReader();

      reader.onLoadEnd.listen((e) async {
        try {
          final jsonString = reader.result as String;

          if (!mounted) return;

          final cubit = context.read<VocabularyCubit>();
          final success = await cubit.importVocabulary(jsonString);

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? 'Vocabulaire importé avec succès !'
                    : 'Format du fichier invalide',
              ),
              backgroundColor: success
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        } catch (e) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors du traitement: ${e.toString()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      });

      reader.readAsText(file);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'importation: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Mon vocabulaire'),
        centerTitle: true,
        actions: [
          BlocBuilder<VocabularyCubit, VocabularyState>(
            builder: (context, state) {
              final hasEntries = state.vocabularyEntries.isNotEmpty;

              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'export') {
                    _handleExport();
                  } else if (value == 'import') {
                    _handleImport();
                  }
                },
                itemBuilder: (BuildContext context) => [
                  if (hasEntries)
                    const PopupMenuItem<String>(
                      value: 'export',
                      child: Row(
                        children: [
                          Icon(Icons.upload),
                          SizedBox(width: 8),
                          Text('Exporter mon vocabulaire'),
                        ],
                      ),
                    ),
                  const PopupMenuItem<String>(
                    value: 'import',
                    child: Row(
                      children: [
                        Icon(Icons.download),
                        SizedBox(width: 8),
                        Text('Importer un fichier de vocabulaire'),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
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
