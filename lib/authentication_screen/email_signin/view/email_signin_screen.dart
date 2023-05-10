import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport_elite_app/dashboard/dashboard_view.dart';

import '../../../router/router.dart';
import '../../../utils/constants.dart';
import '../../../utils/localization_en.dart';
import '../../../widgets/sport_app_rounded_button.dart';
import '../../reset_password/view/reset_password_screen.dart';
import '../presenter/email_signin_presenter.dart';

bool _passwordVisible = false;

class LoginWithMailScreen extends StatefulWidget {
  const LoginWithMailScreen({Key? key}) : super(key: key);

  @override
  State<LoginWithMailScreen> createState() => _LoginWithMailScreenState();
}

@override
void initState() {
  _passwordVisible = false;
}

class _LoginWithMailScreenState extends State<LoginWithMailScreen> {
  final _emailSigninPresenter = EmailSigninPresenter();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isAbsorbed = false;

  // Dispose controllers when there is no use of them
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isAbsorbed,
      child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  scene_signin_signinScreen_error,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              return const DashboardWithDrawer();
            }

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
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
                        height: MediaQuery.of(context).size.height / 17.22,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2.5,
                            horizontal: 40,
                          ),
                          child: Text(
                            scene_watchSigninScreen_signinScreen_title,
                            style: TextStyle(
                              color: yellowColor,
                              fontSize: ScreenUtil().setSp(
                                24,
                              ),
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
                            scene_watchSigninScreen_signinScreen_subTitle,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(
                                14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 40,
                        ),
                        child: TextFormField(
                          validator: ((email) {
                            if (email == null || email.isEmpty) {
                              return scene_inputEmail_signinScreen_emptyTextField;
                            } else if (!_emailSigninPresenter
                                .validateEmail(email)) {
                              return scene_inputEmail_signinScreen_invalidTextField;
                            }
                            return null;
                          }),
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              16,
                            ),
                          ),
                          controller: _emailController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                              left: 10,
                            ),
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
                            labelText: scene_inputEmail_signinScreen_textField,
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
                          vertical: 20,
                          horizontal: 40,
                        ),
                        child: TextFormField(
                          validator: (password) {
                            if (password == null || password.isEmpty) {
                              return scene_inputPassword_signinScreen_emptyTextField;
                            } else if (password.length < 6) {
                              return scene_inputPassword_signinScreen_smallTextField;
                            } else if (password.length > 15) {
                              return scene_inputPassword_signinScreen_largeTextField;
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              16,
                            ),
                          ),
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                              left: 10,
                            ),
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
                            labelText:
                                scene_inputPassword_signinScreen_textField,
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenUtil().setSp(
                                16,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: greenColor,
                              ),
                              onPressed: () {
                                setState(
                                  () {
                                    _passwordVisible = !_passwordVisible;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: SportAppRoundedButton(
                          inputText: scene_signin_signinScreen_button,
                          heightRatio: (844 / 60),
                          buttonColor: yellowColor,
                          widthRatio: (390 / 318),
                          textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              16,
                            ),
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          borderColor: yellowColor,
                          customOnPressed: () {
                            setState(() {
                              isAbsorbed = true;
                            });
                            Future.delayed(const Duration(seconds: 2))
                                .then((value) {
                              setState(() {
                                isAbsorbed = false;
                              });
                            });
                            // Validate the input forms
                            final isValid = _formKey.currentState!.validate();
                            if (!isValid) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      signin_ErrorAlertDialog_title,
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
                                          setState(() {
                                            isAbsorbed = false;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: yellowColor,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
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
                              return;
                            }
                            _emailSigninPresenter
                                .signInWithEmailAndPassword(
                              _emailController,
                              _passwordController,
                            )
                                .then(
                              (value) {
                                String? message = "";
                                setState(
                                  () {
                                    message = value["message"];
                                  },
                                );
                                if (value["status"] == "SUCCESS") {
                                  navigateToAvatarPage(context, false);
                                } else if (value["status"] == "FAILURE") {
                                  message != null
                                      ? Future(
                                          () async {
                                            return showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    signin_ErrorAlertDialog_title,
                                                  ),
                                                  content:
                                                      SingleChildScrollView(
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
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: yellowColor,
                                                        elevation: 0,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
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
                                        )
                                      : Container();
                                }
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 55,
                        ),
                        child: Row(
                          children: [
                            Text(
                              scene_watchSigninScreen_signinScreen_forgotPasswordText,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(
                                  14,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ResetPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                scene_resetPasswordNavigator_signinScreen_inkWell,
                                style: TextStyle(
                                  color: greenColor,
                                  fontSize: ScreenUtil().setSp(
                                    14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          10,
                          25,
                          10,
                          15,
                        ),
                        child: Text(
                          scene_watchSigninScreen_signinScreen_dontHaveAnAccountText,
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              14,
                            ),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: SportAppRoundedButton(
                          inputText: scene_signupNavigator_signinScreen_button,
                          heightRatio: (844 / 60),
                          buttonColor: const Color(
                            0xFF373737,
                          ),
                          widthRatio: (390 / 318),
                          textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              16,
                            ),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          borderColor: const Color(
                            0xFF373737,
                          ),
                          customOnPressed: () {
                            navigateToCreateAccount(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
