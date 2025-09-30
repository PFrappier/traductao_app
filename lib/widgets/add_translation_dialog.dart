import 'package:flutter/material.dart';
import 'package:traductao_app/model/translation.dart';

class AddTranslationDialog extends StatefulWidget {
  const AddTranslationDialog({super.key});

  @override
  State<AddTranslationDialog> createState() => _AddTranslationDialogState();
}

class _AddTranslationDialogState extends State<AddTranslationDialog> {
  final _textController = TextEditingController();
  final _translatedTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
      final newTranslation = Translation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: _textController.text.trim(),
        translatedText: _translatedTextController.text.trim(),
      );
      Navigator.of(context).pop(newTranslation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.add_circle_outline,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          const Text('Ajouter une traduction'),
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
                hintText: 'ex: Bonjour',
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
                hintText: 'ex: Hello',
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
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}
