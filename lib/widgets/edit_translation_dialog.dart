import 'package:flutter/material.dart';
import 'package:traductao_app/model/translation.dart';

class EditTranslationDialog extends StatefulWidget {
  final Translation translation;

  const EditTranslationDialog({
    super.key,
    required this.translation,
  });

  @override
  State<EditTranslationDialog> createState() => _EditTranslationDialogState();
}

class _EditTranslationDialogState extends State<EditTranslationDialog> {
  late TextEditingController _textController;
  late TextEditingController _translatedTextController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.translation.text);
    _translatedTextController = TextEditingController(text: widget.translation.translatedText);
  }

  @override
  void dispose() {
    _textController.dispose();
    _translatedTextController.dispose();
    super.dispose();
  }

  String? _validateText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez entrer le texte';
    }
    return null;
  }

  String? _validateTranslation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez entrer la traduction';
    }
    return null;
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedTranslation = Translation(
        id: widget.translation.id,
        text: _textController.text.trim(),
        translatedText: _translatedTextController.text.trim(),
      );
      Navigator.of(context).pop(updatedTranslation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.edit_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          const Text('Modifier la traduction'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Texte *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.text_fields),
              ),
              validator: _validateText,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _translatedTextController,
              decoration: const InputDecoration(
                labelText: 'Traduction *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.translate),
              ),
              validator: _validateTranslation,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: _handleSubmit,
          child: const Text('Sauvegarder'),
        ),
      ],
    );
  }
}
