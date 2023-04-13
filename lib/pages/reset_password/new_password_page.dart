import 'package:bevis/blocs/blocs/sign_up_email_bloc/sign_up_email_bloc.dart';
import 'package:bevis/main.dart';
import 'package:bevis/pages/signup/signup_page.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:bevis/widgets/buttons/red_bevis_button.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bevis/pages/login/login_with_email_page.dart';
import 'package:page_transition/page_transition.dart';

class NewPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewPasswordPageState();
  }
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _resetKey;
  String _newPassword;

  FocusNode _keyFocusNode;
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpEmailBloc, SingUpState>(
      listener: (context, state) {
        if (ModalRoute.of(context).isCurrent) {
          if (state is ResetPasswordSuccessState) {
            _showLogin();
          } else if (state is ResetPasswordFailState) {
            BotToast.showNotification(
                leading: (cancel) => SizedBox.fromSize(
                    size: const Size(40, 40),
                    child: Image.asset("assets/logo_bevis.png")),
                title: (_) => Text('Sorry'),
                subtitle: (_) => Text("No user found for $_resetKey not found"),
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
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
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
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(50),
                          right: ScreenUtil().setWidth(50)),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new TextFormField(
                              focusNode: _keyFocusNode,
                              decoration:
                                  const InputDecoration(labelText: 'Code'),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) {
                                _fieldFocusChange(
                                    context, _keyFocusNode, _passwordFocusNode);
                              },
                              validator: (value) {
                                print("here  " +
                                    EmailValidator.validate(value.trim())
                                        .toString());
                                if (value.trim().isEmpty) {
                                  return "Please enter the code";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                _resetKey = value.trim();
                              },
                            ),
                            new TextFormField(
                              focusNode: _passwordFocusNode,
                              decoration: const InputDecoration(
                                  labelText: 'New Password'),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return "Please enter new password";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                _newPassword = value.trim();
                              },
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(30)),
                              alignment: Alignment.center,
                              child: RedBevisButton(
                                title: 'Reset Password',
                                isLoading: state.isLoading,
                                spinkitColor: Colors.white,
                                onPressed: () {
                                  if (!state.isLoading) {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      email = _resetKey;
                                      BlocProvider.of<SignUpEmailBloc>(context)
                                          .add(
                                        MakeNewPasswordEvent(
                                          key: _resetKey,
                                          password: _newPassword,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(48)),
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
                                    fontSize: ScreenUtil().setHeight(20)),
                              ))))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLogin() async {
//    Navigator.of(context).push(
//      platformPageRoute(builder: (_) {
//        return LoginWithEmailPage();
//      }),
//    );
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300),
            alignment: Alignment.center,
            child: LoginWithEmailPage()));
  }

  void _showSignUp() async {
//    Navigator.of(context).push(
//      platformPageRoute(builder: (_) {
//        return LoginWithEmailPage();
//      }),
//    );
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300),
            alignment: Alignment.center,
            child: SignUpPage()));
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
