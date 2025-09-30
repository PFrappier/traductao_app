import 'package:flutter/material.dart';
import 'package:traductao_app/model/translation.dart';

class TranslationTile extends StatelessWidget {
  final Translation translation;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onEdit;

  const TranslationTile({
    super.key,
    required this.translation,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        selected: isSelected,
        selectedTileColor: Theme.of(
          context,
        ).colorScheme.secondaryContainer.withValues(alpha: 0.3),
        leading: isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.secondary,
              )
            : Icon(
                Icons.translate,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        title: Text(
          translation.translatedText,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          '🇫🇷 ${translation.text}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: !isSelected
            ? IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: onEdit,
              )
            : null,
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
