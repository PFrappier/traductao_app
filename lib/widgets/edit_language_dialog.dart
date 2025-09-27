import 'package:flutter/material.dart';
import 'package:traductao_app/model/vocabulary_entry.dart';

class EditLanguageDialog extends StatefulWidget {
  final VocabularyEntry entry;

  const EditLanguageDialog({
    super.key,
    required this.entry,
  });

  @override
  State<EditLanguageDialog> createState() => _EditLanguageDialogState();
}

class _EditLanguageDialogState extends State<EditLanguageDialog> {
  late TextEditingController _languageController;
  late TextEditingController _countryCodeController;

  @override
  void initState() {
    super.initState();
    _languageController = TextEditingController(text: widget.entry.language);
    _countryCodeController = TextEditingController(text: widget.entry.countryCode);
  }

  @override
  void dispose() {
    _languageController.dispose();
    _countryCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifier la langue'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _languageController,
            decoration: const InputDecoration(
              labelText: 'Nom de la langue',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _countryCodeController,
            decoration: const InputDecoration(
              labelText: 'Code du pays (ex: fr, es, en)',
              border: OutlineInputBorder(),
              helperText: 'Code à 2 lettres pour le drapeau',
            ),
            maxLength: 2,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            final updatedEntry = VocabularyEntry(
              id: widget.entry.id,
              language: _languageController.text.trim(),
              countryCode: _countryCodeController.text.trim().toLowerCase(),
              translations: widget.entry.translations,
            );
            Navigator.of(context).pop(updatedEntry);
          },
          child: const Text('Sauvegarder'),
        ),
      ],
    );
  }
}