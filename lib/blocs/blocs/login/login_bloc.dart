import 'dart:convert';

import 'package:bevis/blocs/states/base_state.dart';
import 'package:bevis/data/repositories/network_repositories/login_network_repository.dart';
import 'package:bevis/main.dart';
import 'package:bevis/utils/notifications/notification_center.dart';
import 'package:bevis/utils/notifications/notification_events.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_repository/network_repositories/rest_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'login_email_states.dart';
part 'login_event.dart';
part 'login_social_state.dart';

class LoginEmailBloc extends Bloc<LoginEvent, LoginState> {
  LoginNetworkRepository _loginNetworkRepository;

  LoginEmailBloc({@required LoginNetworkRepository networkRepo})
      : _loginNetworkRepository = networkRepo,
        super(
          LoginState(
            isLoading: false,
          ),
        );

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    print("event in bloc " + token);
    if (event is LoginSocialEvent) {
      if (event.provider.contains("facebook")) {
        print("login face");
        yield LoginState(isLoading: true, socialType: SOCIALTYPE.facebook);
      } else {
        print("login google");
        yield LoginState(isLoading: true, socialType: SOCIALTYPE.google);
      }
    }

    if (event is LoginSocialEvent) {
      if (event.provider.contains("facebook") && event.accessToken.isEmpty) {
        yield LoginState(isLoading: true, socialType: SOCIALTYPE.facebook);

        final LoginResult result = await FacebookAuth.instance.login();

        print("after login face");
        if (result == null) {
          yield LoginSocialFailState(
            "",
            isLoading: false,
          );
        }
        switch (result.status) {
          case LoginStatus.success:
            var data = await http.get(Uri.parse(
                "https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${result.accessToken.token}"));
            print(data.body.toString());
            token = result.accessToken.token;
            email = result.accessToken.token;
            password = result.accessToken.token;
            socialType = "facebook";

            final res = await _loginNetworkRepository.loginWithSocial(
                accessToken: token, provider: event.provider);

            var a = res.response as RestRepositoryResponse;
            print("res " + jsonDecode(a.body).toString());

            token = jsonDecode(a.body)["accessToken"];
            if (res.error == null) {
              isLogIn = true;
              saveLogin();
              yield LoginSocialSuccessState(isLoading: false);
            } else {
              yield LoginSocialFailState("", isLoading: false);
            }
            break;
          case LoginStatus.cancelled:
            yield LoginSocialFailState("", isLoading: false);

            break;
          case LoginStatus.failed:
            print("error");
            yield LoginSocialFailState("", isLoading: false);
            break;
          case LoginStatus.operationInProgress:
            break;
        }
      } else if (event.provider.contains("google") &&
          event.accessToken.isEmpty) {
        print("login google token");

        yield LoginState(isLoading: true, socialType: SOCIALTYPE.google);

        GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile']);

        final GoogleSignInAccount googleSignInAccount =
            await _googleSignIn.signIn();

        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleSignInAuthentication =
              await googleSignInAccount.authentication;

          email = googleSignInAuthentication.accessToken;
          password = googleSignInAuthentication.accessToken;
          socialType = "google";
          token = googleSignInAuthentication.accessToken;
          final res = await _loginNetworkRepository.loginWithSocial(
              accessToken: token, provider: event.provider);

          var a = res.response as RestRepositoryResponse;
          print("res " + jsonDecode(a.body).toString());
          token = jsonDecode(a.body)["accessToken"];
          if (res.error == null) {
            isLogIn = true;
            saveLogin();
            yield LoginSocialSuccessState(isLoading: false);
          } else {
            yield LoginSocialFailState("", isLoading: false);
          }
        } else {
          yield LoginSocialFailState("", isLoading: false);
        }
      } else {
        final res = await _loginNetworkRepository.loginWithSocial(
            accessToken: event.accessToken, provider: event.provider);

        var a = res.response as RestRepositoryResponse;
        print("res " + jsonDecode(a.body).toString());
        token = jsonDecode(a.body)["accessToken"];
        if (res.error == null) {
          isLogIn = true;
          saveLogin();
          yield LoginSocialSuccessState(isLoading: false);
        } else {
          yield LoginSocialFailState("", isLoading: false);
        }
      }
    } else if (event is LoginEmailEvent) {
      NotificationCenter.shared().eventBus.fire(Loading());
      yield LoginState(
        isLoading: true,
      );
      final res = await _loginNetworkRepository.login(
          email: event.email,
          password: event.password,
          remeberMe: event.rememberMe);

      if (res.error == null) {
        token = jsonDecode(res.response.body)["accessToken"].toString();
        yield LoginEmailSuccessState();
        isLogIn = true;
        saveLogin();
      } else {
        var error = res.error as NetworkError;

        if (error.errorTitle?.contains("UserNotActivatedException") ?? false) {
          yield LoginEmailActivateState();
        } else {
          var msg = error.errorCode == 403
              ? "Sorry Log In Fail"
              : "Not Registered User";
          yield LoginEmailFailState(message: msg);
        }
      }
    }
  }

  Future<void> saveLogin() async {
    print("in save token" + token);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("login", true);
    sharedPreferences.setString("token", token);
    sharedPreferences.setString("login_time", DateTime.now().toString());
  }
}
