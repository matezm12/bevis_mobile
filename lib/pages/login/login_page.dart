import 'package:bevis/blocs/blocs/login/login_bloc.dart';
import 'package:bevis/main.dart';
import 'package:bevis/pages/home/home_page.dart';
import 'package:bevis/pages/login/widgets/login_option_button.dart';
import 'package:bevis/pages/signup/signup_page.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bevis/pages/login/login_with_email_page.dart';
import 'package:local_auth/local_auth.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 350), () {
      if (isEnableBiometri) {
        bioLogIn();
      }
    });
  }

  Future<void> bioLogIn() async {
    var localAuth = LocalAuthentication();

    bool didAuthenticate = await localAuth.authenticate(
      localizedReason: 'Please authenticate to login into your account',
      biometricOnly: true,
    );
    if (didAuthenticate) {
      if (email == password) {
        //this is socail login
        BlocProvider.of<LoginEmailBloc>(context)
            .add(LoginSocialEvent(socialType, accessToken: email));
      } else {
        //this is email password log in
        BlocProvider.of<LoginEmailBloc>(context).add(
          LoginEmailEvent(email: email, password: password, rememberMe: true),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginEmailBloc, LoginState>(
      listener: (context, state) {
        print("In listener");
        if (ModalRoute.of(context).isCurrent) {
          if (state is LoginSocialSuccessState) {
            Navigator.of(context).pushAndRemoveUntil(
                PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 500),
                  child: HomePage(
                    logInFirstTime: true,
                  ),
                ),
                (route) => false);
          } else if (state is LoginEmailSuccessState) {
            Navigator.of(context).pushAndRemoveUntil(
                PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  duration: Duration(milliseconds: 500),
                  alignment: Alignment.center,
                  child: HomePage(logInFirstTime: true),
                ),
                (route) => false);
          } else if (state is LoginSocialFailState) {
            BotToast.showNotification(
              leading: (cancel) => SizedBox.fromSize(
                  size: const Size(40, 40),
                  child: Image.asset("assets/logo_bevis.png")),
              title: (_) => Text('Sorry'),
              subtitle: (_) => Text("Log in Fail"),
              trailing: (cancel) => IconButton(
                icon: Icon(Icons.cancel),
                onPressed: cancel,
              ),
              enableSlideOff: true,
              crossPage: true,
              contentPadding: EdgeInsets.all(10),
              onlyOne: true,
              animationDuration: Duration(milliseconds: 500),
              animationReverseDuration: Duration(milliseconds: 500),
              duration: Duration(
                seconds: 3,
              ),
            );
          }
        }
      },
      builder: (context, state) {
        print("state change log in" + state.isLoading.toString());

        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(100)),
                    child: Image.asset(
                      "assets/logo_bevis.png",
                      width: ScreenUtil().setWidth(80),
                      height: ScreenUtil().setHeight(100),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
                    child: Text(
                      "Log In your\n Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ColorConstants.textColor,
                          fontSize: ScreenUtil().setHeight(30),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        LoginOptionButton(
                          spinkitColor: Colors.white,
                          title: 'Log in with Facebook',
                          titleTextColor: Colors.white,
                          backgroundColor: ColorConstants.facebookBlue,
                          borderColor: ColorConstants.facebookBlue,
                          isLoading: state.isLoading &&
                              state.socialType == SOCIALTYPE.facebook,
                          onPressed: () {
                            if (!state.isLoading) {
                              BlocProvider.of<LoginEmailBloc>(context)
                                  .add(LoginSocialEvent("facebook"));
                            }
                          },
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        LoginOptionButton(
                          title: 'Log in with Google',
                          spinkitColor: ColorConstants.colorAppRed,
                          isLoading: state.isLoading &&
                              state.socialType == SOCIALTYPE.google,
                          onPressed: () {
                            if (!state.isLoading) {
                              print("in here");
                              BlocProvider.of<LoginEmailBloc>(context)
                                  .add(LoginSocialEvent("google"));
                            }
                          },
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        LoginOptionButton(
                          title: 'Log in with e-mail',
                          isLoading: false,
                          onPressed: () {
                            _showLogin();
                          },
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          margin:
                              EdgeInsets.only(top: ScreenUtil().setHeight(48)),
                          child: Text(
                            "Don't have Account  on Bevis?",
                            style: TextStyle(
                                color: ColorConstants.textColor,
                                fontSize: ScreenUtil().setHeight(12)),
                          )),
                      Container(
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil().setHeight(28)),
                          alignment: Alignment.center,
                          child: Material(
                              child: InkWell(
                                  onTap: () {
                                    _showSignUp();
                                  },
                                  child: Text(
                                    "Sign up Here",
                                    style: TextStyle(
                                        color: ColorConstants.textColor,
                                        fontSize: ScreenUtil().setHeight(20)),
                                  ))))
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLogin() async {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300),
            alignment: Alignment.center,
            child: LoginWithEmailPage()));
  }

  void _showSignUp() async {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300),
            alignment: Alignment.center,
            child: SignUpPage()));
  }
}
