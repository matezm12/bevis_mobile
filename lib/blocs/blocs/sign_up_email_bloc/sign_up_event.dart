part of 'sign_up_email_bloc.dart';

abstract class SignUpEvent {}

class SignUpEmailEvent implements SignUpEvent {
  @required
  final String firstName;
  @required
  final String lastName;
  @required
  final String email;
  @required
  final String password;

  SignUpEmailEvent(
      {@required this.firstName,
      @required this.lastName,
      @required this.email,
      @required this.password});
}

class SignUpActivateCodeEvent implements SignUpEvent {
  final String activationCode;

  SignUpActivateCodeEvent({this.activationCode});
}

class ResetPasswordEvent implements SignUpEvent {
  final String email;

  ResetPasswordEvent({this.email});
}

class MakeNewPasswordEvent implements SignUpEvent {
  final String password;
  final String key;
  MakeNewPasswordEvent({this.key, this.password});
}
