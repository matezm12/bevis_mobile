import 'package:bevis/blocs/blocs/sign_up_email_bloc/sign_up_email_bloc.dart';
import 'package:bevis/main.dart';
import 'package:bevis/pages/reset_password/new_password_page.dart';
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

class ResetPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ResetPasswordPageState();
  }
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpEmailBloc, SingUpState>(
      listener: (context, state) {
        if (ModalRoute.of(context).isCurrent) {
          if (state is ResetPasswordFoundState) {
            BotToast.showNotification(
                leading: (cancel) => SizedBox.fromSize(
                    size: const Size(40, 40),
                    child: Image.asset("assets/logo_bevis.png")),
                title: (_) => Text(''),
                subtitle: (_) => Text("Reset code has been sent to  $_email"),
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
                duration: Duration(seconds: 4));
            _showNewPasswordPage();
          } else if (state is ResetPasswordNotFoundState) {
            BotToast.showNotification(
                leading: (cancel) => SizedBox.fromSize(
                    size: const Size(40, 40),
                    child: Image.asset("assets/logo_bevis.png")),
                title: (_) => Text('Sorry'),
                subtitle: (_) => Text("User with $_email not found"),
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
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                print("here  " +
                                    EmailValidator.validate(value.trim())
                                        .toString());
                                if (!EmailValidator.validate(value.trim())) {
                                  return "Please enter valid email";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                _email = value.trim();
                              },
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(30)),
                              alignment: Alignment.center,
                              child: RedBevisButton(
                                title: 'Send Code',
                                isLoading: state.isLoading,
                                spinkitColor: Colors.white,
                                onPressed: () {
                                  if (!state.isLoading) {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      email = _email;
                                      BlocProvider.of<SignUpEmailBloc>(context)
                                          .add(
                                        ResetPasswordEvent(
                                          email: _email,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 10),
                                alignment: Alignment.center,
                                child: Material(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Go back?",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                        )),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                                          fontSize: ScreenUtil().setHeight(20)),
                                    ))))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showNewPasswordPage() async {
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
            child: NewPasswordPage()));
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
}
