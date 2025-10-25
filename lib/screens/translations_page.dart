import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traductao_app/bloc/vocabulary_cubit.dart';
import 'package:traductao_app/bloc/vocabulary_state.dart';
import 'package:traductao_app/model/translation.dart';
import 'package:traductao_app/widgets/add_translation_dialog.dart';
import 'package:traductao_app/widgets/edit_translation_dialog.dart';
import 'package:traductao_app/widgets/translation_tile.dart';

class MyTranslationsPage extends StatefulWidget {
  final String country;

  const MyTranslationsPage({super.key, required this.country});

  @override
  State<MyTranslationsPage> createState() => _MyTranslationsPageState();
}

class _MyTranslationsPageState extends State<MyTranslationsPage> {
  final Set<String> _selectedTranslationIds = {};

  void _handleAddTranslation(BuildContext context, String languageId) async {
    final result = await showDialog<Translation>(
      context: context,
      builder: (context) => const AddTranslationDialog(),
    );

    if (result != null && context.mounted) {
      context.read<VocabularyCubit>().addTranslation(languageId, result);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Traduction ajoutée avec succès !'),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleEditTranslation(BuildContext context, String languageId, Translation translation) async {
    final result = await showDialog<Translation>(
      context: context,
      builder: (context) => EditTranslationDialog(translation: translation),
    );

    if (result != null && mounted) {
      context.read<VocabularyCubit>().updateTranslation(languageId, result);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Traduction modifiée avec succès !'),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _toggleSelection(String translationId) {
    setState(() {
      if (_selectedTranslationIds.contains(translationId)) {
        _selectedTranslationIds.remove(translationId);
      } else {
        _selectedTranslationIds.add(translationId);
      }
    });
  }

  void _deleteSelectedTranslations(BuildContext context) {
    if (_selectedTranslationIds.isEmpty) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer ${_selectedTranslationIds.length} traduction${_selectedTranslationIds.length > 1 ? 's' : ''} ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<VocabularyCubit>().deleteTranslations(_selectedTranslationIds.toList());
                setState(() {
                  _selectedTranslationIds.clear();
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${_selectedTranslationIds.length} traduction${_selectedTranslationIds.length > 1 ? 's supprimées' : ' supprimée'} !'),
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VocabularyCubit, VocabularyState>(
      builder: (context, state) {
        final entry = state.vocabularyEntries.firstWhere(
          (e) => e.language == widget.country,
          orElse: () => state.vocabularyEntries.first,
        );

        final bool hasSelection = _selectedTranslationIds.isNotEmpty;

        return Scaffold(
          appBar: AppBar(
            title: Text(hasSelection ? '${_selectedTranslationIds.length} sélectionné${_selectedTranslationIds.length > 1 ? 's' : ''}' : widget.country),
            centerTitle: true,
            leading: hasSelection
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _selectedTranslationIds.clear();
                      });
                    },
                  )
                : null,
            actions: hasSelection
                ? [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteSelectedTranslations(context),
                    ),
                  ]
                : null,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: entry.translations.isEmpty
                ? _buildEmptyState(context, entry.id)
                : ListView.builder(
                    itemCount: entry.translations.length,
                    itemBuilder: (context, index) {
                      final translation = entry.translations[index];
                      final isSelected = _selectedTranslationIds.contains(translation.id);

                      return TranslationTile(
                        translation: translation,
                        isSelected: isSelected,
                        onTap: () {
                          if (hasSelection) {
                            _toggleSelection(translation.id);
                          }
                        },
                        onLongPress: () => _toggleSelection(translation.id),
                        onEdit: () => _handleEditTranslation(context, entry.id, translation),
                        onToggleQuiz: () {
                          context.read<VocabularyCubit>().toggleQuizInclusion(entry.id, translation.id);
                        },
                      );
                    },
                  ),
          ),
          floatingActionButton: hasSelection
              ? null
              : FloatingActionButton(
                  onPressed: () => _handleAddTranslation(context, entry.id),
                  tooltip: 'Ajouter une traduction',
                  child: const Icon(Icons.add),
                ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String languageId) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.translate,
            size: 80,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 24),
          Text(
            'Aucune traduction',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Appuie sur + pour ajouter ta première traduction',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
