import 'package:flutter/material.dart';
import '../../../router/router.dart';
import '../interactor/authentication_type_interactor.dart';
import 'dart:developer' as dev;

class AuthenticationTypePresenter {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<dynamic> facebookPresenter(BuildContext context) async {
    return await AuthenticationTypeInteractor()
        .signInWithFacebook()
        .then((value) {
      Navigator.of(context).pop();
      if (value == "newUser") {
        navigateToUserTypeSelectionScreen(context);
        dev.log("[FACEBOOK LOGIN] Navigate to User Type Screen");
      }
      if (value == "existingUser") {
        navigateToDashboard(context);
        dev.log("[FACEBOOK LOGIN] Navigate to Home Screen");
      }
    });
  }

  Future<dynamic> googlePresenter(BuildContext context) async {
    return await AuthenticationTypeInteractor()
        .signInWithGoogle()
        .then((value) {
      Navigator.of(context).pop();
      if (value == true) {
        navigateToUserTypeSelectionScreen(context);
        dev.log("[GOOGLE LOGIN] Navigate to User Type Screen");
      } else {
        navigateToDashboard(context);
        dev.log("[GOOGLE LOGIN] Navigate to Home Screen");
      }
    });
  }
}
