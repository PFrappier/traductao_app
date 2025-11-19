import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traductao_app/bloc/vocabulary_cubit.dart';
import 'package:traductao_app/bloc/vocabulary_state.dart';
import 'package:traductao_app/model/translation.dart';
import 'package:traductao_app/widgets/add_translation_dialog.dart';
import 'package:traductao_app/widgets/edit_translation_dialog.dart';
import 'package:traductao_app/widgets/translation_tile.dart';

class GroupTranslationsPage extends StatefulWidget {
  final String groupName;
  final String languageId;
  final String groupId;

  const GroupTranslationsPage({
    super.key,
    required this.groupName,
    required this.languageId,
    required this.groupId,
  });

  @override
  State<GroupTranslationsPage> createState() => _GroupTranslationsPageState();
}

class _GroupTranslationsPageState extends State<GroupTranslationsPage> {
  final Set<String> _selectedTranslationIds = {};

  void _toggleSelection(String translationId) {
    setState(() {
      if (_selectedTranslationIds.contains(translationId)) {
        _selectedTranslationIds.remove(translationId);
      } else {
        _selectedTranslationIds.add(translationId);
      }
    });
  }

  void _handleEditTranslation(BuildContext context, Translation translation) async {
    final result = await showDialog<Translation>(
      context: context,
      builder: (context) => EditTranslationDialog(translation: translation),
    );

    if (result != null && mounted) {
      context.read<VocabularyCubit>().updateTranslation(
        widget.languageId,
        widget.groupId,
        result,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Traduction modifiée avec succès !'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleAddTranslation(BuildContext context) async {
    final result = await showDialog<Translation>(
      context: context,
      builder: (context) => const AddTranslationDialog(),
    );

    if (result != null && mounted) {
      context.read<VocabularyCubit>().addTranslation(
        widget.languageId,
        widget.groupId,
        result,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Traduction ajoutée avec succès !'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
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
                final count = _selectedTranslationIds.length;
                Navigator.of(dialogContext).pop();
                context.read<VocabularyCubit>().deleteTranslations(
                  widget.languageId,
                  widget.groupId,
                  _selectedTranslationIds.toList(),
                );
                setState(() {
                  _selectedTranslationIds.clear();
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$count traduction${count > 1 ? 's supprimées' : ' supprimée'} !'),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
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
        final group = context.read<VocabularyCubit>().getGroupById(
          widget.languageId,
          widget.groupId,
        );

        if (group == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.groupName),
            ),
            body: const Center(
              child: Text('Groupe introuvable'),
            ),
          );
        }

        final bool hasSelection = _selectedTranslationIds.isNotEmpty;

        return Scaffold(
          appBar: AppBar(
            title: Text(hasSelection ? '${_selectedTranslationIds.length} sélectionné${_selectedTranslationIds.length > 1 ? 's' : ''}' : widget.groupName),
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
            child: group.translations.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    itemCount: group.translations.length,
                    itemBuilder: (context, index) {
                      final translation = group.translations[index];
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
                        onEdit: () => _handleEditTranslation(context, translation),
                        onToggleQuiz: () {
                          context.read<VocabularyCubit>().toggleQuizInclusion(
                            widget.languageId,
                            widget.groupId,
                            translation.id,
                          );
                        },
                      );
                    },
                  ),
          ),
          floatingActionButton: hasSelection
              ? null
              : FloatingActionButton(
                  onPressed: () => _handleAddTranslation(context),
                  tooltip: 'Ajouter une traduction',
                  child: const Icon(Icons.add),
                ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
            'Appuie sur + pour ajouter une traduction\nà ce groupe',
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
