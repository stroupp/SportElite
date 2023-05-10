import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as dev;
import 'package:sport_elite_app/utils/shared_preferences_helper.dart';

class EmailSigninInteractor {
  // Send a sign in call to Firebase Auth API and return the result
  Future<Map<String, String>> getFirebaseSignInResult(
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then(
        (value) {
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            dev.log("SIGN IN SUCCESSFUL");
            SharedPreferencesHelper.setUID(currentUser.uid);

            return {
              "status": "SUCCESS",
              "message": "User signed in successfully",
            };
          } else {
            dev.log("SIGN IN FAILED");
            return {
              "status": "FAILURE",
              "message": "User signed in failed",
            };
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      dev.log(e.message!);
      return {
        "status": "FAILURE",
        "message": e.message!,
      };
    }
    return {
      "status": "FAILURE",
    };
  }
}
