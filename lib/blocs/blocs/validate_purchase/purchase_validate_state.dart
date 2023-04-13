part of 'purchase_validate_bloc.dart';

class PurchaseValidateState extends BaseState {
  final PurchasedItem purchasedItem;
  PurchaseValidateState(this.purchasedItem, {bool isLoading = false})
      : super(isLoading: isLoading);
}

class SuccessPurchaseValidateState extends PurchaseValidateState {
  final String balance;

  SuccessPurchaseValidateState(this.balance, PurchasedItem purchasedItem)
      : super(purchasedItem);
}

class DuplicatePurchaseValidateState extends PurchaseValidateState {
  DuplicatePurchaseValidateState(PurchasedItem purchasedItem)
      : super(purchasedItem);
}

class FailPurchaseValidateState extends PurchaseValidateState {
  String message;

  FailPurchaseValidateState(
      {@required this.message, PurchasedItem purchasedItem})
      : super(purchasedItem);
}
