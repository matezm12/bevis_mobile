import 'package:bevis/blocs/blocs/sign_up_email_bloc/sign_up_email_bloc.dart';
import 'package:bevis/pages/login/login_with_email_page.dart';
import 'package:bevis/utils/alert_constants.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:bevis/widgets/buttons/red_bevis_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ActivateAccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ActivateAccountPageState();
  }
}

class ActivateAccountPageState extends State<ActivateAccountPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _activationCode;
  ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = ProgressDialog(context);
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(375, 723),
    );
    return BlocConsumer<SignUpEmailBloc, SingUpState>(
      listener: (context, state) {
        if (state is SignUpActivateSuccessState) {
          _progressDialog.hide();

          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  duration: Duration(milliseconds: 500),
                  alignment: Alignment.center,
                  child: LoginWithEmailPage()));
        } else if (state is SignUpActivateFailState) {
          _progressDialog.hide();
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(AlertConstants.ErrorTitle),
                  content: Text('Sorry, Activation  failed'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text(AlertConstants.OkButtonTitle),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              });
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
                          left: ScreenUtil().setWidth(10),
                          right: ScreenUtil().setWidth(10)),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              child: Container(
                                width: 200,
                                child: TextFormField(
                                  decoration:
                                      const InputDecoration(labelText: 'Code'),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Please enter activation code";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    _activationCode = value;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 200,
                              child: Text(
                                "Please check your email for the verification code",
                                style: TextStyle(
                                    color: ColorConstants.textColor,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: ScreenUtil().setHeight(30),
                        bottom: ScreenUtil().setHeight(50)),
                    child: RedBevisButton(
                      title: 'Activate',
                      isLoading: state.isLoading,
                      spinkitColor: Colors.white,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _progressDialog.show();
                          BlocProvider.of<SignUpEmailBloc>(context).add(
                            SignUpActivateCodeEvent(
                              activationCode: _activationCode,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
