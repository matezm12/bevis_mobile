import 'package:bevis/blocs/blocs/sign_up_email_bloc/sign_up_email_bloc.dart';
import 'package:bevis/pages/login/login_page.dart';
import 'package:bevis/pages/signup/activation_page.dart';
import 'package:bevis/utils/color_constants.dart';
import 'package:bevis/widgets/buttons/red_bevis_button.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

// ignore: must_be_immutable
class SignUpEmailPage extends StatefulWidget {
  String firstName;
  String lastName;
  String password;
  String email;

  SignUpEmailPage({this.firstName, this.lastName, this.email});

  @override
  State<StatefulWidget> createState() {
    return SignUpEmailPageState();
  }
}

class SignUpEmailPageState extends State<SignUpEmailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTextEditController =
      TextEditingController();
  final TextEditingController _firstNameTextEditController =
      TextEditingController();
  final TextEditingController _lastNameTextEditController =
      TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _secondNameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _lastNameTextEditController.text = widget.lastName;
    _firstNameTextEditController.text = widget.firstName;
    _emailTextEditController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpEmailBloc, SingUpState>(
      listener: (context, state) {
        if (state is SignUpSuccessState) {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeftWithFade,
              duration: Duration(milliseconds: 500),
              alignment: Alignment.center,
              child: ActivateAccountPage(),
            ),
          );
        } else if (state is SignUpFailState) {
          BotToast.showNotification(
              leading: (cancel) => SizedBox.fromSize(
                  size: const Size(40, 40),
                  child: Image.asset("assets/logo_bevis.png")),
              title: (_) => Text('Sorry'),
              subtitle: (_) => Text(state.msg),
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
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: SafeArea(
              bottom: true,
              top: false,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(100)),
                        child: Image.asset(
                          "assets/logo_bevis.png",
                          width: ScreenUtil().setWidth(80),
                          height: ScreenUtil().setHeight(90),
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
                              children: <Widget>[
                                new TextFormField(
                                  focusNode: _emailFocus,
                                  controller: _emailTextEditController,
                                  decoration:
                                      const InputDecoration(labelText: 'Email'),
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (value) {
                                    _fieldFocusChange(
                                        context, _emailFocus, _firstNameFocus);
                                  },
                                  validator: (value) {
                                    print("here  " +
                                        EmailValidator.validate(value)
                                            .toString());
                                    if (!EmailValidator.validate(value)) {
                                      return "Please enter valid email";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    widget.email = value.trim();
                                  },
                                ),
                                new TextFormField(
                                  focusNode: _firstNameFocus,
                                  controller: _firstNameTextEditController,
                                  onFieldSubmitted: (value) {
                                    _fieldFocusChange(context, _firstNameFocus,
                                        _secondNameFocus);
                                  },
                                  decoration: const InputDecoration(
                                      labelText: 'First Name'),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Please enter first name";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    widget.firstName = value.trim();
                                  },
                                ),
                                new TextFormField(
                                  focusNode: _secondNameFocus,
                                  controller: _lastNameTextEditController,
                                  onFieldSubmitted: (value) {
                                    _fieldFocusChange(context, _secondNameFocus,
                                        _passwordFocus);
                                  },
                                  decoration: const InputDecoration(
                                      labelText: 'Last Name'),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Please enter last name";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) {
                                    widget.lastName = value.trim();
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
                                    widget.password = value;
                                  },
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(30)),
                                  child: RedBevisButton(
                                    title: 'Sign Up',
                                    isLoading: state.isLoading,
                                    spinkitColor: Colors.white,
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();

                                        BlocProvider.of<SignUpEmailBloc>(
                                                context)
                                            .add(SignUpEmailEvent(
                                                firstName: widget.firstName,
                                                lastName: widget.lastName,
                                                password: widget.password,
                                                email: widget.email));
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(15)),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: 'By signing up you accept the ',
                                        style: TextStyle(
                                            color: ColorConstants.textColor,
                                            fontSize:
                                                ScreenUtil().setHeight(12)),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          margin:
                              EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                          child: Text(
                            "Already on Bevis?",
                            style: TextStyle(
                                color: ColorConstants.textColor,
                                fontSize: ScreenUtil().setHeight(12)),
                          )),
                      InkWell(
                        onTap: () {
                          _showLogin();
                        },
                        child: Container(
                            margin: EdgeInsets.only(
                                bottom: ScreenUtil().setHeight(20)),
                            alignment: Alignment.center,
                            child: Text(
                              "Log in",
                              style: TextStyle(
                                  color: ColorConstants.textColor,
                                  fontSize: ScreenUtil().setHeight(20)),
                            )),
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

  void _showLogin() async {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        duration: Duration(milliseconds: 500),
        alignment: Alignment.center,
        child: LoginPage(),
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
