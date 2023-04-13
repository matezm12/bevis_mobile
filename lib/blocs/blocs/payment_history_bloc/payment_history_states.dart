part of 'payment_history_bloc.dart';

class PaymentHistoryState extends BaseState {
  PaymentHistoryState({bool isLoading = false}) : super(isLoading: isLoading);
}

class SuccessLoadPaymentHistoryState extends PaymentHistoryState {
  final PaymentHistoryPagination histories;

  SuccessLoadPaymentHistoryState(this.histories);
}

class FailLoadPaymentHistoryState extends PaymentHistoryState {
  String message;

  FailLoadPaymentHistoryState({@required this.message});
}
