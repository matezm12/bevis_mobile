import 'package:bevis/blocs/states/base_state.dart';
import 'package:bevis/data/models/bevis_asset.dart';
import 'package:bevis/data/models/currency.dart';

class AssetListState extends BaseState {
  final BevisAssetPagination bevisAssetPagination;
  final Currency selectedCurrency;
  final double coinListValueSum;
  final Future loadCoinsFuture;

  AssetListState(
      {bool isLoading,
      this.bevisAssetPagination,
      this.selectedCurrency,
      this.loadCoinsFuture,
      this.coinListValueSum})
      : super(isLoading: isLoading);

  @override
  AssetListState copyWith(
      {bool isLoading,
      BevisAssetPagination assets,
      Currency selectedCurrency,
      Future loadCoinsFuture,
      double coinListValueSum}) {
    return AssetListState(
      isLoading: isLoading ?? this.isLoading,
      bevisAssetPagination: assets ?? this.bevisAssetPagination,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      loadCoinsFuture: loadCoinsFuture ?? this.loadCoinsFuture,
      coinListValueSum: coinListValueSum ?? this.coinListValueSum,
    );
  }
}
