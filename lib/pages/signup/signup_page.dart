import 'package:bevis/blocs/blocs/login/login_bloc.dart';
import 'package:bevis/pages/home/home_page.dart';
import 'package:bevis/pages/login/login_page.dart';
import 'package:bevis/pages/login/widgets/login_option_button.dart';
import 'package:bevis/pages/signup/singup_email_page.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginEmailBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSocialSuccessState) {
          Navigator.push(
              context,
              PageTransition(
                  duration: Duration(milliseconds: 300),
                  type: PageTransitionType.rightToLeftWithFade,
                  alignment: Alignment.bottomCenter,
                  child: HomePage(logInFirstTime: true)));
        } else if (state is LoginSocialFailState) {
//          showPlatformDialog(
//              context: context,
//              builder: (context) {
//                return PlatformAlertDialog(
//                  title: Text(AlertConstants.ErrorTitle),
//                  content: Text('Sorry, Log in failed'),
//                  actions: <Widget>[
//                    PlatformDialogAction(
//                      child: Text(AlertConstants.OkButtonTitle),
//                      onPressed: () => Navigator.of(context).pop(),
//                    ),
//                  ],
//                );
//              });
          BotToast.showNotification(
              leading: (cancel) => SizedBox.fromSize(
                  size: const Size(40, 40),
                  child: Image.asset("assets/logo_bevis.png")),
              title: (_) => Text('Sorry'),
              subtitle: (_) => Text("Sign up fail"),
              trailing: (cancel) => IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: cancel,
                  ),
              enableSlideOff: true,
              crossPage: true,
              contentPadding: EdgeInsets.all(10),
              onlyOne: true,
              animationDuration: Duration(milliseconds: 300),
              animationReverseDuration: Duration(milliseconds: 300),
              duration: Duration(seconds: 3));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            top: false,
            bottom: true,
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(114)),
                      child: Image.asset(
                        "assets/logo_bevis.png",
                        width: ScreenUtil().setWidth(80),
                        height: ScreenUtil().setHeight(106),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(80)),
                      child: Text(
                        "Create Secure\n Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorConstants.textColor,
                            fontSize: ScreenUtil().setHeight(40),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: ScreenUtil().setHeight(240),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          LoginOptionButton(
                            spinkitColor: Colors.white,
                            title: 'Sign up with Facebook',
                            titleTextColor: Colors.white,
                            backgroundColor: ColorConstants.facebookBlue,
                            borderColor: ColorConstants.facebookBlue,
                            isLoading: state.isLoading &&
                                state.socialType == SOCIALTYPE.facebook,
                            onPressed: () {
                              if (!state.isLoading) {
                                BlocProvider.of<LoginEmailBloc>(context).add(
                                  LoginSocialEvent("facebook"),
                                );
                              }
                            },
                          ),
                          LoginOptionButton(
                            title: 'Sign up with Google',
                            spinkitColor: ColorConstants.colorAppRed,
                            isLoading: state.isLoading &&
                                state.socialType == SOCIALTYPE.google,
                            onPressed: () {
                              if (!state.isLoading) {
                                print("in here");
                                BlocProvider.of<LoginEmailBloc>(context).add(
                                  LoginSocialEvent("google"),
                                );
                              }
                            },
                          ),
                          LoginOptionButton(
                            title: 'Sign up with e-mail',
                            isLoading: false,
                            onPressed: () {
                              _showSignUpwithEmail();
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'By signing up you accept the ',
                            style: TextStyle(
                                color: ColorConstants.textColor,
                                fontSize: ScreenUtil().setHeight(12)),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Terms of\n Service',
                                style: TextStyle(
                                  color: ColorConstants.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: ColorConstants.textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )),
                    Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(48)),
                        child: Text(
                          "Already on Bevis?",
                          style: TextStyle(
                              color: ColorConstants.textColor,
                              fontSize: ScreenUtil().setHeight(12)),
                        )),
                    Container(
                        alignment: Alignment.center,
                        child: Material(
                            child: InkWell(
                                onTap: () {
                                  _showLogin();
                                },
                                child: Text(
                                  "Log in",
                                  style: TextStyle(
                                      color: ColorConstants.textColor,
                                      fontSize: ScreenUtil().setHeight(20)),
                                ))))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSignUpwithEmail() async {
    Navigator.push(
      context,
      PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.rightToLeftWithFade,
        alignment: Alignment.bottomCenter,
        child: SignUpEmailPage(),
      ),
    );
  }

  void _showLogin() async {
    Navigator.push(
      context,
      PageTransition(
        duration: Duration(milliseconds: 300),
        type: PageTransitionType.rightToLeftWithFade,
        alignment: Alignment.bottomCenter,
        child: LoginPage(),
      ),
    );
  }
}
