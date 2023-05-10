import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as dev;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sport_elite_app/choose_avatar_screen/interactor/choose_avatar_interactor.dart';
import '../../utils/shared_preferences_helper.dart';

abstract class IFirebaseUser {
  User? getCurrentFirebaseUser();
}

class HomeScreenInteractor implements IFirebaseUser {
  @override
  User? getCurrentFirebaseUser() {
    try {
      return FirebaseAuth.instance.currentUser!;
    } on FirebaseAuthException catch (e) {
      dev.log(
        "[HomeScreen Interactor]",
        error: e,
      );
    }
    return null;
  }

  // Sign out current firebase user from the application
  void signOutFirebaseUser() => FirebaseAuth.instance.signOut();

  static Future<Image?> getFirestoreImage() async {
    String ppPath;
    int i = await ChooseAvatarInteractor.getPPImageIndex();
    String uid = await SharedPreferencesHelper.getUID();
    if (i == -1) {
      final FirebaseStorage storage = FirebaseStorage.instance;
      String imgURL =
          await storage.ref().child("profile_pictures/$uid").getDownloadURL();
      var img = Image.network(imgURL);
      return img;
    } else {
      return Image.asset("assets/images/placeholders/user.png");
    }
  }

  static Future<String> getFireStorePpPath(String uid) async {
    final _firestore = FirebaseFirestore.instance;
    try {
      var document = await _firestore.collection('users').doc(uid).get();
      DocumentSnapshot<Map<String, dynamic>> data = document;
      var path = data["pp_path"];
      return path;
    } catch (e) {
      log(e.toString());
    }
    return "-1";
  }

  static Future<String> getPpUrlOfUser(String uid) async {
    String path = await getFireStorePpPath(uid);
    String url = await ChooseAvatarInteractor.getUrlWithLoc(path);
    return url;
  }
}
