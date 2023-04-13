import 'package:bevis/blocs/states/base_state.dart';
import 'package:bevis/data/repositories/network_repositories/top_up_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';

part 'purchase_validate_event.dart';
part 'purchase_validate_state.dart';

class PurchaseValidateBloc
    extends Bloc<PurchaseValidateEvent, PurchaseValidateState> {
  TopUpNetworkRepository _topUpNetworkRepository;

  PurchaseValidateBloc({@required TopUpNetworkRepository networkRepo})
      : _topUpNetworkRepository = networkRepo,
        super(
          PurchaseValidateState(null, isLoading: false),
        );

  @override
  Stream<PurchaseValidateState> mapEventToState(
    PurchaseValidateEvent event,
  ) async* {
    if (event is ValidatePurchaseEvent) {
      print("purchase" + event.purchasedItem.transactionId);
      final result = await _topUpNetworkRepository.validatePurchase(
          purchaseId: event.purchaseId,
          provider: event.provider,
          productId: event.productId,
          receiptData: event.receiptData);
      if (result.error == null) {
        print("verify pacakage " + result.resultValue.toString());
        yield SuccessPurchaseValidateState(
            result.resultValue, event.purchasedItem);
      } else {
        print("purchase" + event.purchasedItem.transactionId);

        NetworkError networkError = result.error;
        print("IN error" + networkError.toString());
        if (networkError.errorCode == 403 &&
            networkError.type == "DuplicateCreditsChargeException") {
          yield DuplicatePurchaseValidateState(event.purchasedItem);
        }
        yield FailPurchaseValidateState(
            message: networkError.errorMsg, purchasedItem: event.purchasedItem);
      }
    }
  }
}
