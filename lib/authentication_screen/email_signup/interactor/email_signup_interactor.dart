import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sport_elite_app/authentication_screen/authentication_type/interactor/authentication_type_interactor.dart';
import 'package:sport_elite_app/utils/shared_preferences_helper.dart';
import 'dart:developer' as dev;

class EmailSignupInteractor {
  AuthenticationTypeInteractor authenticationTypeInteractor =
      AuthenticationTypeInteractor();

  // Send a sign up call to Firebase Auth API and return the result
  Future<Map<String, String>> getFirebaseSignUpResult(
      TextEditingController usernameController,
      TextEditingController emailController,
      TextEditingController passwordController,
      String userType) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then(
        (value) async {
          User user = FirebaseAuth.instance.currentUser!;
          authenticationTypeInteractor.setUser(
              user, usernameController.text.trim());
          SharedPreferencesHelper.setUID(user.uid);

          return {
            'success': 'SUCCESS',
            'message': 'User created successfully',
          };
        },
      );
    } on FirebaseAuthException catch (e) {
      dev.log('Interactor: ${e.message!}');
      return {
        'status': 'FAILURE',
        'message': e.message!,
      };
    } on FirebaseException catch (e) {
      dev.log('Interactor: ${e.message!}');
      return {
        'status': 'FAILURE',
        'message': e.message!,
      };
    }

    return {
      'status': 'FAILURE',
      'message': 'Something went wrong :/',
    };
  }
}
