import 'package:bevis/data/models/currency.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';
import 'package:meta/meta.dart';

abstract class SelectCurrencyState {}

class LoadingCurrencies extends SelectCurrencyState {}

class FailedToLoadCurrencies extends SelectCurrencyState {
  final NetworkError error;

  FailedToLoadCurrencies(this.error);
}

class CurrenciesLoaded extends SelectCurrencyState {
  final List<Currency> popularCurrencies;
  final List<Currency> otherCurrencies;

  CurrenciesLoaded({@required this.popularCurrencies, @required this.otherCurrencies});
}

class DefaultCurrencySaved extends SelectCurrencyState {
  final Currency selectedCurrency;

  DefaultCurrencySaved(this.selectedCurrency);
}