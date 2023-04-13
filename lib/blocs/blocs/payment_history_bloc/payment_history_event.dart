part of 'payment_history_bloc.dart';

abstract class PaymentHistoryEvent {}

class LoadPaymentHistoryEvent implements PaymentHistoryEvent {
  LoadPaymentHistoryEvent();
}
