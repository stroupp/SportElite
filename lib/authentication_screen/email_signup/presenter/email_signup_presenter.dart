import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../../email_signin/presenter/email_signin_presenter.dart';
import '../interactor/email_signup_interactor.dart';

class EmailSignupPresenter implements IValidateEmail {
  final EmailSignupInteractor _signupInteractor = EmailSignupInteractor();

  EmailSignupInteractor get signupInteractor => _signupInteractor;

  Future<Map<String, String>> signUp(
    TextEditingController usernameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    String userType,
  ) async {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      return {
        'status': 'FAILED',
        'message': 'Please enter valid username, email, and password',
      };
    }

    return _signupInteractor.getFirebaseSignUpResult(
      usernameController,
      emailController,
      passwordController,
      userType,
    );
  }

  // Validate email with EmailValidator plugin
  @override
  bool validateEmail(String email) {
    return EmailValidator.validate(email);
  }
}
