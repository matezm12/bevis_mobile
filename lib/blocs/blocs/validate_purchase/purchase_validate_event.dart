part of 'purchase_validate_bloc.dart';

abstract class PurchaseValidateEvent {}

class ValidatePurchaseEvent implements PurchaseValidateEvent {
  final String productId;
  final String purchaseId;
  final String receiptData;
  final String provider;
  final PurchasedItem purchasedItem;
  ValidatePurchaseEvent(
      {@required this.productId,
      @required this.purchasedItem,
      @required this.purchaseId,
      @required this.receiptData,
      @required this.provider});
}
