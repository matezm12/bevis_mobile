part of 'credit_package_bloc.dart';

class CreditPackageState extends BaseState {
  CreditPackageState({bool isLoading = false}) : super(isLoading: isLoading);
}

class SuccessLoadCreditPackageState extends CreditPackageState {
  final List<CreditPackage> packages;

  SuccessLoadCreditPackageState(this.packages);
}

class FailLoadCreditPackageState extends CreditPackageState {
  String message;

  FailLoadCreditPackageState({@required this.message});
}
