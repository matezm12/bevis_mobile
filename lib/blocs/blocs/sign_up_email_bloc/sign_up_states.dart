part of 'sign_up_email_bloc.dart';

class SingUpState extends BaseState {
  SingUpState({bool isLoading = false}) : super(isLoading: isLoading);
}

class SignUpSuccessState extends SingUpState {}

class SignUpFailState extends SingUpState {
  final String msg;

  SignUpFailState(this.msg);
}

class SignUpActivateSuccessState extends SingUpState {}

class SignUpActivateFailState extends SingUpState {}

class ResetPasswordFoundState extends SingUpState {}

class ResetPasswordNotFoundState extends SingUpState {}

class ResetPasswordSuccessState extends SingUpState {}

class ResetPasswordFailState extends SingUpState {}
