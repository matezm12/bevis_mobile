part of 'login_bloc.dart';

enum SOCIALTYPE { google, facebook }

class LoginState extends BaseState {
  SOCIALTYPE socialType;
  LoginState({bool isLoading = false, this.socialType})
      : super(isLoading: isLoading);
}

class LoginEmailSuccessState extends LoginState {}

class LoginEmailActivateState extends LoginState {}

class LoginEmailFailState extends LoginState {
  String message;

  LoginEmailFailState({@required this.message});
}
