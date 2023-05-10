import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../../../home_screen/interactor/home_screen_interactor.dart';
import '../interactor/email_signin_interactor.dart';
import 'dart:developer' as dev;

abstract class IValidateEmail {
  bool validateEmail(String email);
}

class EmailSigninPresenter implements IValidateEmail {
  final EmailSigninInteractor _signinInteractor = EmailSigninInteractor();
  final HomeScreenInteractor _homeScreenInteractor = HomeScreenInteractor();

  EmailSigninInteractor get interactor => _signinInteractor;

  HomeScreenInteractor get homeScreenInteractor => _homeScreenInteractor;

  // Sign-in user with email and password
  Future<Map<String?, String?>> signInWithEmailAndPassword(
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      dev.log("Invalid email and password");
      return {
        'status': 'FAILED',
        'message': 'Please enter valid email and password',
      };
    }

    return _signinInteractor.getFirebaseSignInResult(
      emailController,
      passwordController,
    );
  }

  @override
  bool validateEmail(String email) {
    return EmailValidator.validate(email);
  }
}
