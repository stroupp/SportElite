import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_elite_app/router/router.dart';
import '../../home_screen/interactor/home_screen_interactor.dart';
import 'dart:developer' as dev;

class ProfileEditInteractor {
  editProfileInfo(
    BuildContext context,
    TextEditingController username,
    TextEditingController aboutMe,
    TextEditingController interests,
    TextEditingController university,
    TextEditingController speciality,
    TextEditingController company,
  ) async {
    User user = FirebaseAuth.instance.currentUser!;
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {
          "username": username.text.trim(),
          "aboutMe": aboutMe.text.trim(),
          "interests": interests.text.trim(),
          "university": university.text.trim(),
          "speciality": speciality.text.trim(),
          "company": company.text.trim(),
        },
      ).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text(
              "Your data has been saved!",
            ),
          ),
        );
        navigateToDashboard(context);
      });
    } catch (e) {
      dev.log(e.toString());
    }
  }

  Future<String> getUserAvatarUrl(String? uid) async {
    return await HomeScreenInteractor.getPpUrlOfUser(uid!);
  }
}
