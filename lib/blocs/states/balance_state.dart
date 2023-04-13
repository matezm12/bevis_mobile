import 'package:bevis/blocs/states/base_state.dart';

class BalanceInfoState extends BaseState {
  final String balance;

  BalanceInfoState({this.balance = "", bool isLoading = false})
      : super(isLoading: isLoading);
}
