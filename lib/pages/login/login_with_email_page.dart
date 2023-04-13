import 'package:bevis/blocs/blocs/login/login_bloc.dart';
import 'package:bevis/main.dart';
import 'package:bevis/pages/home/home_page.dart';
import 'package:bevis/pages/reset_password/reset_password_page.dart';
import 'package:bevis/pages/signup/activation_page.dart';
import 'package:bevis/pages/signup/signup_page.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:bevis/widgets/buttons/red_bevis_button.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class LoginWithEmailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginWithEmailPageState();
  }
}

class _LoginWithEmailPageState extends State<LoginWithEmailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _password;
  String _email;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginEmailBloc, LoginState>(
      listener: (context, state) {
        if (ModalRoute.of(context).isCurrent) {
          if (state is LoginEmailSuccessState) {
            Navigator.push(
                context,
                PageTransition(
                    duration: Duration(milliseconds: 500),
                    type: PageTransitionType.rightToLeftWithFade,
                    alignment: Alignment.center,
                    child: HomePage(logInFirstTime: true)));
          } else if (state is LoginEmailActivateState) {
            Navigator.push(
              context,
              PageTransition(
                duration: Duration(milliseconds: 500),
                type: PageTransitionType.rightToLeftWithFade,
                alignment: Alignment.center,
                child: ActivateAccountPage(),
              ),
            );
          } else if (state is LoginEmailFailState) {
//            print("Login in fail");
            BotToast.showNotification(
                leading: (cancel) => SizedBox.fromSize(
                    size: const Size(40, 40),
                    child: Image.asset("assets/logo_bevis.png")),
                title: (_) => Text('Sorry'),
                subtitle: (_) => Text(state.message),
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
                duration: Duration(seconds: 3));
          }
        }
      },
      builder: (context, state) {
        print("state change " + MediaQuery.of(context).size.height.toString());
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(114)),
                        child: Image.asset(
                          "assets/logo_bevis.png",
                          width: ScreenUtil().setWidth(80),
                          height: ScreenUtil().setHeight(106),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(50),
                                right: ScreenUtil().setWidth(50)),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new TextFormField(
                                    focusNode: _emailFocus,
                                    decoration: const InputDecoration(
                                        labelText: 'Email'),
                                    onFieldSubmitted: (value) {
                                      _fieldFocusChange(
                                          context, _emailFocus, _passwordFocus);
                                    },
                                    enableSuggestions: true,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      print("here  " +
                                          EmailValidator.validate(value.trim())
                                              .toString());
                                      if (!EmailValidator.validate(
                                          value.trim())) {
                                        return "Please enter valid email";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      _email = value.trim();
                                    },
                                  ),
                                  new TextFormField(
                                    focusNode: _passwordFocus,
                                    decoration: const InputDecoration(
                                        labelText: 'Password'),
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    textInputAction: TextInputAction.done,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Please enter password";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      _password = value;
                                    },
                                  ),
                                  RedBevisButton(
                                    title: "Log in",
                                    onPressed: () {
                                      if (!state.isLoading) {
                                        if (_formKey.currentState.validate()) {
                                          _formKey.currentState.save();
                                          email = _email;
                                          password = _password;
                                          BlocProvider.of<LoginEmailBloc>(
                                                  context)
                                              .add(
                                            LoginEmailEvent(
                                                email: _email,
                                                password: _password,
                                                rememberMe: true),
                                          );
                                        }
                                      }
                                    },
                                    isLoading: state.isLoading,
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 10),
                                      alignment: Alignment.center,
                                      child: Material(
                                        child: InkWell(
                                          onTap: () {
                                            _showRestPassword();
                                          },
                                          child: Text("Forget your password?",
                                              style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                              )),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(48)),
                                child: Text(
                                  "Don't have Account  on Bevis?",
                                  style: TextStyle(
                                      color: ColorConstants.textColor,
                                      fontSize: ScreenUtil().setHeight(12)),
                                )),
                            Container(
                                margin: EdgeInsets.only(
                                    bottom: ScreenUtil().setHeight(30),
                                    top: ScreenUtil().setHeight(10)),
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
                                              fontSize:
                                                  ScreenUtil().setHeight(20)),
                                        ))))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSignUp() async {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            alignment: Alignment.bottomCenter,
            child: SignUpPage()));
  }

  void _showRestPassword() async {
    Navigator.push(
        context,
        PageTransition(
            duration: Duration(milliseconds: 300),
            type: PageTransitionType.rightToLeftWithFade,
            alignment: Alignment.bottomCenter,
            child: ResetPasswordPage()));
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
