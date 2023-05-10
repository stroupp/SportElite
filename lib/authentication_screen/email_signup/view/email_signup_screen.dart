import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport_elite_app/user_type_selection_screen/view/user_type_selection_screen.dart';

import '../../../utils/constants.dart';
import '../../../utils/localization_en.dart';
import '../../../utils/shared_preferences_helper.dart';
import '../../../widgets/sport_app_rounded_button.dart';
import '../presenter/email_signup_presenter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

bool _isPasswordInvisible = true;

class _SignUpScreenState extends State<SignUpScreen> {
  final _signupPresenter = EmailSignupPresenter();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Dispose controllers when there is no use of them
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _userType;

  @override
  void initState() {
    _userType = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("userType") ?? "";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                scene_signup_signupScreen_error,
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            return const UserTypeSelectionScreen();
          }

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_sharp, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height / 17.22),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.5,
                          horizontal: 40,
                        ),
                        child: Text(
                          scene_watchSignupScreen_signupScreen_title,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              24,
                            ),
                            color: yellowColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.5,
                          horizontal: 40,
                        ),
                        child: Text(
                          scene_watchSignupScreen_signupScreen_subTitle,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff04764e),
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                          ),
                          labelText: scene_inputUsername_signupScreen_textField,
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(
                              16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      child: TextFormField(
                        validator: ((email) {
                          if (email == null || email.isEmpty) {
                            return scene_inputEmail_signupScreen_emptyTextField;
                          } else if (!_signupPresenter.validateEmail(email)) {
                            return scene_inputEmail_signupScreen_invalidTextField;
                          }
                          return null;
                        }),
                        controller: _emailController,
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: greenColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                          ),
                          labelText: scene_inputEmail_signupScreen_textField,
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(
                              16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      child: TextFormField(
                        //TODO: extract method
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return scene_inputPassword_signupScreen_emptyTextField;
                          } else if (password.length < 6) {
                            return scene_inputPassword_signupScreen_smallTextField;
                          } else if (password.length > 15) {
                            return scene_inputPassword_signupScreen_largeTextField;
                          }
                          return null;
                        },
                        controller: _passwordController,
                        obscureText: _isPasswordInvisible,
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: greenColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                          ),
                          labelText: scene_inputPassword_signupScreen_textField,
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(
                              16,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordInvisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: greenColor,
                            ),
                            onPressed: () {
                              setState(
                                () {
                                  _isPasswordInvisible = !_isPasswordInvisible;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Center(
                        child: SportAppRoundedButton(
                          inputText: scene_signup_signupScreen_button,
                          heightRatio: (844 / 60),
                          buttonColor: const Color(0xff373737),
                          widthRatio: (390 / 318),
                          textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              16,
                            ),
                            color: const Color(0xffFFFFFF),
                            fontWeight: FontWeight.bold,
                          ),
                          borderColor: const Color(0xff373737),
                          customOnPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            String userType = "Default";
                            await SharedPreferencesHelper.getUserType()
                                .then((value) => userType = value);
                            _signupPresenter
                                .signUp(
                              _usernameController,
                              _emailController,
                              _passwordController,
                              userType,
                            )
                                .then(
                              (value) {
                                if (value["status"] == 'FAILED') {
                                  Future(
                                    () async {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              signup_ErrorAlertDialog_title,
                                            ),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: const [
                                                  Text(
                                                    scene_signin_signinScreen_errorSnackBar,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: yellowColor,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20,
                                                    ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  signin_AlertDialogButton_text,
                                                  style: TextStyle(
                                                    color: blackColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          text:
                              scene_watchSignupScreen_signupScreen_termsAndConditions,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            color:
                                dashboardAddTraineeTermsAndConditionsGreyColor,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: scene_seeTerms_signupScreen_inkWell,
                                style: TextStyle(
                                  color: greenColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(
                                    14,
                                  ),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // code to open / launch terms of service link here
                                  }),
                            TextSpan(
                              text: scene_watchSignupScreen_signupScreen_and,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(
                                  14,
                                ),
                                color:
                                    dashboardAddTraineeTermsAndConditionsGreyColor,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      scene_seeConditions_signupScreen_inkWell,
                                  style: TextStyle(
                                    color: greenColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(
                                      14,
                                    ),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // code to open / launch privacy policy link here
                                    },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
