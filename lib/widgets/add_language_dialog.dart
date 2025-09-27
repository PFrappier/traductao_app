import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traductao_app/model/vocabulary_entry.dart';
import 'package:traductao_app/bloc/vocabulary_cubit.dart';

class AddLanguageDialog extends StatefulWidget {
  const AddLanguageDialog({super.key});

  @override
  State<AddLanguageDialog> createState() => _AddLanguageDialogState();
}

class _AddLanguageDialogState extends State<AddLanguageDialog> {
  final _languageController = TextEditingController();
  final _countryCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _languageController.dispose();
    _countryCodeController.dispose();
    super.dispose();
  }

  String? _validateLanguage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez entrer le nom de la langue';
    }

    // Vérifier si la langue existe déjà
    final cubit = context.read<VocabularyCubit>();
    if (cubit.languageExists(value.trim())) {
      return 'Cette langue existe déjà dans votre vocabulaire';
    }

    return null;
  }

  String? _validateCountryCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez entrer le code du pays';
    }
    if (value.trim().length != 2) {
      return 'Le code doit contenir exactement 2 lettres';
    }
    if (!RegExp(r'^[a-zA-Z]{2}$').hasMatch(value.trim())) {
      return 'Le code doit contenir uniquement des lettres';
    }
    return null;
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final newEntry = VocabularyEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        language: _languageController.text.trim(),
        countryCode: _countryCodeController.text.trim().toLowerCase(),
        translations: [],
      );
      Navigator.of(context).pop(newEntry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.add_circle_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          const Text('Ajouter une langue'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _languageController,
              decoration: const InputDecoration(
                labelText: 'Nom de la langue *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.language),
                hintText: 'ex: Français, Espagnol, Anglais',
              ),
              validator: _validateLanguage,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _countryCodeController,
              decoration: const InputDecoration(
                labelText: 'Code du pays *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag),
                hintText: 'ex: fr, es, en, de',
                helperText: 'Code à 2 lettres pour afficher le drapeau',
              ),
              validator: _validateCountryCode,
              maxLength: 2,
              textCapitalization: TextCapitalization.none,
              onChanged: (value) {
                // Convertir automatiquement en minuscules
                if (value != value.toLowerCase()) {
                  _countryCodeController.value = _countryCodeController.value.copyWith(
                    text: value.toLowerCase(),
                    selection: TextSelection.fromPosition(
                      TextPosition(offset: value.toLowerCase().length),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Le code pays permet d\'afficher le bon drapeau. Exemples : fr (France), es (Espagne), gb (Royaume-Uni), de (Allemagne).',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
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