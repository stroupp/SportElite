import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class ResetPasswordInteractor {
  Future resetPassword(
      TextEditingController email, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.text.trim())
          .then(
        (value) {
          const snackBar = SnackBar(
            content: Text(
                "Reset password email has been sent. Please check your spam folder!"),
          );
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      );
    } on FirebaseAuthException catch (e) {
      const snackBar = SnackBar(
        content: Text("Error: Could not sent the reset password email!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      dev.log("${e.message}");
    }
  }
}
