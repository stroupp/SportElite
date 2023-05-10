import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sport_elite_app/utils/shared_preferences_helper.dart';

class AuthenticationTypeInteractor {
  Future<void> setUser(User user, String userName) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          'uid': user.uid,
          'email': user.email,
          'username': userName,
          'aboutMe': "",
          'interests': "",
          'university': "",
          'speciality': "",
          'company': ""
        },
      );
    } catch (e) {
      dev.log("problem : ${e.toString()}");
    }
  }

  Map<String, dynamic>? _userObj;

  Map<String, dynamic>? get userObj => _userObj;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance
          .login(permissions: ['email', 'public_profile']);
      if (result.status == LoginStatus.success) {
        // final AccessToken accessToken = result.accessToken!;
        final OAuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);

        UserCredential userCredentials = await FirebaseAuth.instance
            .signInWithCredential(facebookCredential);

        if (userCredentials.additionalUserInfo!.isNewUser) {
          User user = FirebaseAuth.instance.currentUser!;
          setUser(user, user.displayName.toString());
          SharedPreferencesHelper.setUID(user.uid);
          return "newUser";
        } else {
          return "existingUser";
        }
      } else if (result.status == LoginStatus.cancelled) {
        dev.log("[Facebook] login cancelled");
      } else if (result.status == LoginStatus.failed) {
        dev.log("[Facebook] login failed");
      } else {
        dev.log("[Facebook]${result.status.toString()}");
        dev.log(result.message.toString());
      }
    } catch (e) {
      dev.log(e.toString());
    }
    return "error";
  }

  Future<Map<String, dynamic>> getUserDataFromFacebook() async {
    final userData = await FacebookAuth.instance.getUserData();
    _userObj = userData;
    return userData;
  }

  Future<void> logOutFromFacebook() async {
    try {
      await FacebookAuth.instance.logOut();
      await auth.signOut();
      _userObj = null;
    } catch (e) {
      dev.log(e.toString());
    }
  }

  GoogleSignInAccount? googleUser;

  Future<bool> signInWithGoogle() async {
    googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredentials =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredentials.additionalUserInfo!.isNewUser) {
      User user = FirebaseAuth.instance.currentUser!;
      setUser(user, user.displayName.toString());
      SharedPreferencesHelper.setUID(user.uid);
      return true;
    } else {
      return false;
    }
  }
}
