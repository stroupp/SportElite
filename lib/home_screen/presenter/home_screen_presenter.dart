import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import '../../authentication_screen/authentication_type/interactor/authentication_type_interactor.dart';
import '../../router/router.dart';
import '../interactor/home_screen_interactor.dart';

class HomeScreenPresenter {
  final HomeScreenInteractor _homePageInteractor = HomeScreenInteractor();

  AuthenticationTypeInteractor authenticationTypeInteractor =
      AuthenticationTypeInteractor();

  HomeScreenInteractor get homePageInteractor => _homePageInteractor;

  User? getCurrentUser() {
    if (FirebaseAuth.instance.currentUser != null) {
      return _homePageInteractor.getCurrentFirebaseUser();
    }
    dev.log('No user signed in');
    return null;
  }

  void signOut(BuildContext context) {
    if (authenticationTypeInteractor.userObj != null) {
      authenticationTypeInteractor.logOutFromFacebook();
      navigateToLoginTypePage(context);
    } else if (FirebaseAuth.instance.currentUser != null) {
      _homePageInteractor.signOutFirebaseUser();
      navigateToLoginTypePage(context);
    } else {
      dev.log('No user to sign out');
    }
  }
}
