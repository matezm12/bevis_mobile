import 'package:bevis/blocs/states/base_state.dart';
import 'package:bevis/data/repositories/network_repositories/top_up_repository.dart';
import 'package:bevis/data/top_up/payment_history.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';

part 'payment_history_states.dart';
part 'payment_history_event.dart';

class PaymentHistoryBloc
    extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  TopUpNetworkRepository _topUpNetworkRepository;

  PaymentHistoryBloc({@required TopUpNetworkRepository networkRepo})
      : _topUpNetworkRepository = networkRepo,
        super(
          PaymentHistoryState(
            isLoading: false,
          ),
        );

  @override
  Stream<PaymentHistoryState> mapEventToState(
    PaymentHistoryEvent event,
  ) async* {
    if (event is LoadPaymentHistoryEvent) {
      final result = await _topUpNetworkRepository.getPaymentHistory();
      if (result.error == null) {
        print("get pacakges " + result.resultValue.toString());

        yield SuccessLoadPaymentHistoryState(result.resultValue);
      } else {
        NetworkError networkError = result.error;
        yield FailLoadPaymentHistoryState(message: networkError.errorMsg);
      }
    }
  }
}
