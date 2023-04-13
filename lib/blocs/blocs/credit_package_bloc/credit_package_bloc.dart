import 'package:bevis/blocs/states/base_state.dart';
import 'package:bevis/data/repositories/network_repositories/top_up_repository.dart';
import 'package:bevis/data/top_up/package.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';

part 'credit_package_states.dart';
part 'credit_package_event.dart';

class CreditPackageBloc extends Bloc<CreditPackageEvent, CreditPackageState> {
  TopUpNetworkRepository _topUpNetworkRepository;

  CreditPackageBloc({@required TopUpNetworkRepository networkRepo})
      : _topUpNetworkRepository = networkRepo,
        super(
          CreditPackageState(
            isLoading: false,
          ),
        );

  @override
  Stream<CreditPackageState> mapEventToState(
    CreditPackageEvent event,
  ) async* {
    if (event is LoadCreditPackageEvent) {
      final result = await _topUpNetworkRepository.getPackages();
      if (result.error == null) {
        print("get pacakges " + result.resultValue.toString());
        yield SuccessLoadCreditPackageState(result.resultValue);
      } else {
        NetworkError networkError = result.error;
        yield FailLoadCreditPackageState(message: networkError.errorMsg);
      }
    }
  }
}
