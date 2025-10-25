import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:traductao_app/bloc/countries_state.dart';
import 'package:traductao_app/model/country.dart';

class CountriesCubit extends Cubit<CountriesState> {
  static const String _baseUrl = 'https://restcountries.com/v3.1';

  CountriesCubit() : super(const CountriesState());

  Future<void> loadCountries() async {
    if (state.status == CountriesStatus.success) {
      // Les pays sont déjà chargés, ne pas recharger
      return;
    }

    emit(state.copyWith(status: CountriesStatus.loading));

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/all?fields=name,translations,cca2,flag'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        final countries = jsonData
            .map((countryJson) => Country.fromJson(countryJson))
            .toList();

        // Trier par nom pour une meilleure UX
        countries.sort((a, b) => a.name.compareTo(b.name));

        emit(state.copyWith(
          status: CountriesStatus.success,
          countries: countries,
        ));
      } else {
        throw Exception('Erreur lors du chargement des pays: ${response.statusCode}');
      }
    } catch (e) {
      // En cas d'erreur, utiliser une liste de pays par défaut
      final defaultCountries = _getDefaultCountries();
      emit(state.copyWith(
        status: CountriesStatus.success,
        countries: defaultCountries,
        errorMessage: 'Connexion limitée - liste de pays réduite',
      ));
    }
  }

  Country? findCountryByCode(String code) {
    try {
      return state.countries.firstWhere(
        (country) => country.code.toLowerCase() == code.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  List<Country> searchCountries(String query) {
    if (query.isEmpty) return state.countries;

    final lowercaseQuery = query.toLowerCase();
    return state.countries
        .where((country) =>
            country.name.toLowerCase().contains(lowercaseQuery) ||
            country.code.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  List<Country> _getDefaultCountries() {
    // Liste de secours avec les pays les plus courants
    return [
      Country(name: 'France', code: 'fr', flag: '🇫🇷'),
      Country(name: 'Espagne', code: 'es', flag: '🇪🇸'),
      Country(name: 'Royaume-Uni', code: 'gb', flag: '🇬🇧'),
      Country(name: 'États-Unis', code: 'us', flag: '🇺🇸'),
      Country(name: 'Allemagne', code: 'de', flag: '🇩🇪'),
      Country(name: 'Italie', code: 'it', flag: '🇮🇹'),
      Country(name: 'Portugal', code: 'pt', flag: '🇵🇹'),
      Country(name: 'Russie', code: 'ru', flag: '🇷🇺'),
      Country(name: 'Chine', code: 'cn', flag: '🇨🇳'),
      Country(name: 'Japon', code: 'jp', flag: '🇯🇵'),
      Country(name: 'Brésil', code: 'br', flag: '🇧🇷'),
      Country(name: 'Mexique', code: 'mx', flag: '🇲🇽'),
      Country(name: 'Canada', code: 'ca', flag: '🇨🇦'),
      Country(name: 'Australie', code: 'au', flag: '🇦🇺'),
      Country(name: 'Inde', code: 'in', flag: '🇮🇳'),
    ]..sort((a, b) => a.name.compareTo(b.name));
  }

  void clearCache() {
    emit(const CountriesState());
  }
}
