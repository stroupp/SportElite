import 'package:flutter/material.dart';
import 'package:sport_elite_app/authentication_screen/reset_password/interactor/reset_password_interactor.dart';
import '../../../utils/constants.dart';

class ResetPasswordPresenter {
  TextEditingController email = TextEditingController();

  ResetPasswordInteractor resetPasswordInteractor = ResetPasswordInteractor();

  Future resetPasswordPresenter(BuildContext context) async {
    if (email.text.isNotEmpty) {
      if (RegExp(regexCode).hasMatch(email.text)) {
        await resetPasswordInteractor.resetPassword(email, context);
      } else {
        const snackBar = SnackBar(
          content: Text("Your mail address is not valid. Please try again."),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      const snackBar = SnackBar(
        content: Text("Email needs to be filled"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
