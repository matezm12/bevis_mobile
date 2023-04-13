part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginEmailEvent implements LoginEvent {
  final String email;
  final String password;
  final bool rememberMe;

  LoginEmailEvent({
    @required this.email,
    @required this.password,
    @required this.rememberMe,
  });
}

class LoginSocialEvent implements LoginEvent {
  final String accessToken;
  final String provider;

  LoginSocialEvent(this.provider, {this.accessToken = ""});
}
