import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traductao_app/model/vocabulary_entry.dart';
import 'package:traductao_app/model/country.dart';
import 'package:traductao_app/bloc/vocabulary_cubit.dart';
import 'package:traductao_app/widgets/country_selector.dart';

class AddLanguageDialog extends StatefulWidget {
  const AddLanguageDialog({super.key});

  @override
  State<AddLanguageDialog> createState() => _AddLanguageDialogState();
}

class _AddLanguageDialogState extends State<AddLanguageDialog> {
  final _languageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Country? _selectedCountry;

  @override
  void dispose() {
    _languageController.dispose();
    super.dispose();
  }

  String? _validateLanguage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez entrer le nom de la langue';
    }

    // Vérifier si la langue existe déjà
    final cubit = context.read<VocabularyCubit>();
    if (cubit.languageExists(value.trim())) {
      return 'Cette langue existe déjà dans ton vocabulaire';
    }

    return null;
  }


  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final newEntry = VocabularyEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        language: _languageController.text.trim(),
        countryCode: _selectedCountry?.code ?? '',
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Drapeau (optionnel)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                CountrySelector(
                  selectedCountry: _selectedCountry,
                  onCountrySelected: (country) {
                    setState(() {
                      _selectedCountry = country;
                    });
                  },
                  hintText: 'Sélectionner un drapeau',
                ),
              ],
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