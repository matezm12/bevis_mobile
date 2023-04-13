import 'package:bevis/data/models/currency.dart';

abstract class SelectCurrencyEvent {}

class LoadCurrencies extends SelectCurrencyEvent {}

class UserDidSelectCurrency extends SelectCurrencyEvent {
  final Currency selectedCurrency;

  UserDidSelectCurrency(this.selectedCurrency);
}