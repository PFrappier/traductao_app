import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traductao_app/bloc/countries_cubit.dart';
import 'package:traductao_app/bloc/countries_state.dart';
import 'package:traductao_app/model/country.dart';

class CountrySelector extends StatefulWidget {
  final Country? selectedCountry;
  final Function(Country) onCountrySelected;
  final String? hintText;

  const CountrySelector({
    super.key,
    this.selectedCountry,
    required this.onCountrySelected,
    this.hintText,
  });

  @override
  State<CountrySelector> createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  @override
  void initState() {
    super.initState();
    // Charger les pays au démarrage
    context.read<CountriesCubit>().loadCountries();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showCountryPicker(),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              Icons.flag,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: widget.selectedCountry != null
                  ? Row(
                      children: [
                        Text(
                          widget.selectedCountry!.flag,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.selectedCountry!.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      widget.hintText ?? 'Sélectionner un drapeau',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        String searchQuery = '';
        List<Country> filteredCountries = [];

        return StatefulBuilder(
          builder: (context, setModalState) {
            void filterCountries(String query, List<Country> allCountries) {
              setModalState(() {
                searchQuery = query;
                if (query.isEmpty) {
                  filteredCountries = allCountries;
                } else {
                  filteredCountries = allCountries
                      .where((country) =>
                          country.name.toLowerCase().contains(query.toLowerCase()) ||
                          country.code.toLowerCase().contains(query.toLowerCase()))
                      .toList();
                }
              });
            }

            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              builder: (context, scrollController) => Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Sélectionner un drapeau',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: BlocBuilder<CountriesCubit, CountriesState>(
                        builder: (context, state) {
                          return TextField(
                            decoration: InputDecoration(
                              hintText: 'Rechercher un pays...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            onChanged: (query) => filterCountries(query, state.countries),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: BlocBuilder<CountriesCubit, CountriesState>(
                        builder: (context, state) {
                          // Initialiser les pays filtrés si nécessaire
                          if (filteredCountries.isEmpty && searchQuery.isEmpty && state.countries.isNotEmpty) {
                            filteredCountries = state.countries;
                          }

                          if (state.status == CountriesStatus.loading) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (state.status == CountriesStatus.error) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Erreur de chargement',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            );
                          }

                          final displayCountries = searchQuery.isEmpty ? state.countries : filteredCountries;

                          return displayCountries.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 48,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Aucun pays trouvé',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      Text(
                                        'Essayez un autre terme de recherche',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  controller: scrollController,
                                  itemCount: displayCountries.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      final isSelected = widget.selectedCountry == null || widget.selectedCountry!.code.isEmpty;
                                      return Column(
                                        children: [
                                          ListTile(
                                            leading: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                                borderRadius: BorderRadius.circular(4),
                                                border: Border.all(
                                                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.clear,
                                                size: 16,
                                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                            title: const Text('Aucun drapeau'),
                                            trailing: isSelected
                                                ? Icon(
                                                    Icons.check_circle,
                                                    color: Theme.of(context).colorScheme.secondary,
                                                  )
                                                : null,
                                            selected: isSelected,
                                            onTap: () {
                                              widget.onCountrySelected(Country(name: '', code: '', flag: ''));
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          const Divider(height: 1),
                                        ],
                                      );
                                    }

                                    // Éléments suivants : pays
                                    final country = displayCountries[index - 1];
                                    final isSelected = widget.selectedCountry?.code == country.code;

                                    return ListTile(
                                      leading: Text(
                                        country.flag,
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                      title: Text(country.name),
                                      trailing: isSelected
                                          ? Icon(
                                              Icons.check_circle,
                                              color: Theme.of(context).colorScheme.secondary,
                                            )
                                          : null,
                                      selected: isSelected,
                                      onTap: () {
                                        widget.onCountrySelected(country);
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}