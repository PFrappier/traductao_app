import 'package:flutter/material.dart';
import 'package:traductao_app/model/vocabulary_entry.dart';
import 'package:traductao_app/model/country.dart';
import 'package:traductao_app/services/countries_service.dart';
import 'package:traductao_app/widgets/country_selector.dart';

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
  Country? _selectedCountry;
  final CountriesService _countriesService = CountriesService.instance;

  @override
  void initState() {
    super.initState();
    _languageController = TextEditingController(text: widget.entry.language);
    _loadCurrentCountry();
  }

  Future<void> _loadCurrentCountry() async {
    try {
      await _countriesService.getCountries();
      final country = _countriesService.findCountryByCode(widget.entry.countryCode);
      if (country != null) {
        setState(() {
          _selectedCountry = country;
        });
      }
    } catch (e) {
      // En cas d'erreur, garder null
    }
  }

  @override
  void dispose() {
    _languageController.dispose();
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
                hintText: 'Sélectionner un drapeau (optionnel)',
              ),
            ],
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
            if (_languageController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Veuillez entrer le nom de la langue'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            final updatedEntry = VocabularyEntry(
              id: widget.entry.id,
              language: _languageController.text.trim(),
              countryCode: _selectedCountry?.code ?? widget.entry.countryCode,
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