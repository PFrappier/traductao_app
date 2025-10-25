import 'package:traductao_app/model/country.dart';

enum CountriesStatus { initial, loading, success, error }

class CountriesState {
  final CountriesStatus status;
  final List<Country> countries;
  final String? errorMessage;

  const CountriesState({
    this.status = CountriesStatus.initial,
    this.countries = const [],
    this.errorMessage,
  });

  CountriesState copyWith({
    CountriesStatus? status,
    List<Country>? countries,
    String? errorMessage,
  }) {
    return CountriesState(
      status: status ?? this.status,
      countries: countries ?? this.countries,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
