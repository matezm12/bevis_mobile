part of 'login_bloc.dart';

class LoginSocialState extends LoginState {
  LoginSocialState({bool isLoading}) : super(isLoading: isLoading);
}

class LoginSocialSuccessState extends LoginSocialState {
  LoginSocialSuccessState({bool isLoading = false})
      : super(isLoading: isLoading);
}

class LoginSocialFailState extends LoginSocialState {
  final String msg;
  LoginSocialFailState(this.msg, {bool isLoading = false})
      : super(isLoading: isLoading);
}
