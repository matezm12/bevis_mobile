import 'package:bevis/blocs/events/balance_event_bloc.dart';
import 'package:bevis/blocs/states/balance_state.dart';
import 'package:bevis/data/repositories/network_repositories/balance_network_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

class BalanceInfoBloc extends Bloc<BalanceInfoEvent, BalanceInfoState> {
  BalanceNetworkRepository _balanceNetworkRepository;

  BalanceInfoBloc({@required BalanceNetworkRepository balanceNetworkRepository})
      : _balanceNetworkRepository = balanceNetworkRepository,
        super(
          BalanceInfoState(isLoading: true),
        );

  @override
  Stream<BalanceInfoState> mapEventToState(
    BalanceInfoEvent event,
  ) async* {
    if (event is LoadBalanceInfo) {
      final res = await _balanceNetworkRepository.getBalance();
      if (res.error == null) {
        print('no error');
        yield BalanceInfoState(balance: res.resultValue);
      } else {
        print(' error');

        yield BalanceInfoState(balance: "N/A");
      }
    }
  }
}
