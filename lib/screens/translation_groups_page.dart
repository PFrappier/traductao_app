import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traductao_app/bloc/vocabulary_cubit.dart';
import 'package:traductao_app/bloc/vocabulary_state.dart';
import 'package:traductao_app/model/translation_pack.dart';
import 'package:traductao_app/screens/group_translations_page.dart';

class TranslationGroupsPage extends StatefulWidget {
  final String country;
  final String languageId;

  const TranslationGroupsPage({
    super.key,
    required this.country,
    required this.languageId,
  });

  @override
  State<TranslationGroupsPage> createState() => _TranslationGroupsPageState();
}

class _TranslationGroupsPageState extends State<TranslationGroupsPage> {
  final Set<String> _selectedGroupIds = {};

  void _toggleSelection(String groupId) {
    setState(() {
      if (_selectedGroupIds.contains(groupId)) {
        _selectedGroupIds.remove(groupId);
      } else {
        _selectedGroupIds.add(groupId);
      }
    });
  }

  void _showAddGroupDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.create_new_folder_outlined,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              const Text('Nouveau groupe'),
            ],
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom du groupe *',
                    hintText: 'Ex: Vocabulaire de base',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.folder_outlined),
                  ),
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer un nom';
                    }
                    return null;
                  },
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optionnel)',
                    hintText: 'Ex: Mots essentiels pour débuter',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () {
                if (!(formKey.currentState?.validate() ?? false)) return;

                final newGroup = TranslationGroup(
                  id: '${widget.languageId}_group_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameController.text.trim(),
                  translations: [],
                  description: descController.text.trim().isEmpty
                      ? null
                      : descController.text.trim(),
                );

                context.read<VocabularyCubit>().addGroup(widget.languageId, newGroup);
                Navigator.of(dialogContext).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Groupe "${newGroup.name}" créé !'),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Créer'),
            ),
          ],
        );
      },
    );
  }

  void _showEditGroupDialog(BuildContext context, TranslationGroup group) {
    final nameController = TextEditingController(text: group.name);
    final descController = TextEditingController(text: group.description ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              const Text('Modifier le groupe'),
            ],
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom du groupe *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.folder_outlined),
                  ),
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer un nom';
                    }
                    return null;
                  },
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optionnel)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () {
                if (!(formKey.currentState?.validate() ?? false)) return;

                final updatedGroup = group.copyWith(
                  name: nameController.text.trim(),
                  description: descController.text.trim().isEmpty
                      ? null
                      : descController.text.trim(),
                );

                context.read<VocabularyCubit>().updateGroup(widget.languageId, updatedGroup);
                Navigator.of(dialogContext).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Groupe modifié !'),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Sauvegarder'),
            ),
          ],
        );
      },
    );
  }

  void _deleteSelectedGroups(BuildContext context) {
    if (_selectedGroupIds.isEmpty) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer ${_selectedGroupIds.length} groupe${_selectedGroupIds.length > 1 ? 's' : ''} et toutes leurs traductions ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                final count = _selectedGroupIds.length;
                Navigator.of(dialogContext).pop();
                context.read<VocabularyCubit>().deleteGroups(
                  widget.languageId,
                  _selectedGroupIds.toList(),
                );
                setState(() {
                  _selectedGroupIds.clear();
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$count groupe${count > 1 ? 's supprimés' : ' supprimé'} !'),
                    backgroundColor: Theme.of(context).colorScheme.error,
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
          (e) => e.id == widget.languageId,
          orElse: () => state.vocabularyEntries.first,
        );

        final acquiredGroups = entry.groups.where((g) => g.isAcquired).length;
        final totalGroups = entry.groups.length;
        final progressPercentage = totalGroups > 0 ? (acquiredGroups / totalGroups * 100).toInt() : 0;

        final bool hasSelection = _selectedGroupIds.isNotEmpty;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(hasSelection
                ? '${_selectedGroupIds.length} sélectionné${_selectedGroupIds.length > 1 ? 's' : ''}'
                : widget.country),
            centerTitle: true,
            leading: hasSelection
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _selectedGroupIds.clear();
                      });
                    },
                  )
                : null,
            actions: hasSelection
                ? [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteSelectedGroups(context),
                    ),
                  ]
                : null,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Carte de progression
                if (entry.groups.isNotEmpty) ...[
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Progression',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$acquiredGroups/$totalGroups groupes acquis',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  '${entry.totalTranslations} traductions',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: totalGroups > 0 ? acquiredGroups / totalGroups : 0,
                                    minHeight: 6,
                                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Text(
                              '$progressPercentage%',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                // Liste des groupes
                Expanded(
                  child: entry.groups.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          itemCount: entry.groups.length,
                          itemBuilder: (context, index) {
                            final group = entry.groups[index];
                            return _buildGroupCard(context, group, hasSelection);
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: hasSelection
              ? null
              : FloatingActionButton(
                  onPressed: () => _showAddGroupDialog(context),
                  tooltip: 'Créer un groupe',
                  child: const Icon(Icons.add),
                ),
        );
      },
    );
  }

  Widget _buildGroupCard(BuildContext context, TranslationGroup group, bool hasSelection) {
    final isSelected = _selectedGroupIds.contains(group.id);
    final showAcquiredStyle = group.isAcquired && !isSelected;

    return Opacity(
      opacity: showAcquiredStyle ? 0.5 : 1.0,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 1,
        color: isSelected
            ? Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.3)
            : null,
        child: InkWell(
          onTap: () {
            if (hasSelection) {
              _toggleSelection(group.id);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupTranslationsPage(
                    groupName: group.name,
                    languageId: widget.languageId,
                    groupId: group.id,
                  ),
                ),
              );
            }
          },
          onLongPress: () => _toggleSelection(group.id),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.check_circle,
                      size: 28,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )
                else
                  IconButton(
                    icon: Icon(
                      group.isAcquired ? Icons.check_circle : Icons.check_circle_outline,
                      size: 28,
                    ),
                    color: group.isAcquired
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    onPressed: () {
                      context.read<VocabularyCubit>().toggleGroupAcquired(widget.languageId, group.id);
                    },
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${group.translations.length} traduction${group.translations.length > 1 ? 's' : ''}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (group.description != null && group.description!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            group.description!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (showAcquiredStyle && group.acquiredDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Acquis le ${_formatDate(group.acquiredDate!)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (!hasSelection)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () => _showEditGroupDialog(context, group),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 24),
          Text(
            'Aucun groupe',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Crée des groupes pour organiser\ntes traductions',
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
