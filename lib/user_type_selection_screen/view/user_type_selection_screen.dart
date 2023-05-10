import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport_elite_app/authentication_screen/authentication_type/interactor/authentication_type_interactor.dart';

import '../../router/router.dart';
import '../../utils/constants.dart';
import '../../widgets/sport_app_rounded_button.dart';

class UserTypeSelectionScreen extends StatefulWidget {
  const UserTypeSelectionScreen({Key? key}) : super(key: key);

  @override
  State<UserTypeSelectionScreen> createState() =>
      _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String userType = "default";
  int chooseNumber = 1;

  AuthenticationTypeInteractor authenticationTypeInteractor =
  AuthenticationTypeInteractor();

  @override
  void initState() {
    super.initState();
    chooseNumber = 1;
  }

  Future<bool> _onBackPressed() async {
    navigateToLoginTypePage(context);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .delete();
    FirebaseAuth.instance.currentUser?.delete();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red.withOpacity(0),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_sharp, color: Colors.black),
            onPressed: () async {
              navigateToLoginTypePage(context);
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .delete();
              FirebaseAuth.instance.currentUser?.delete();
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width / (844 / 150),
              ),
              Text("Who would you like to\ncontinue as ?",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(
                        25,
                      ),
                      color: yellowColor,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              SizedBox(
                height: MediaQuery.of(context).size.width / (844 / 150),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        chooseNumber = 2;
                        userType = "trainee";
                      });
                    },
                    child: Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xFF373737),
                              ),
                              height: 152,
                              width: 141,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        width: 2,
                                        color: (chooseNumber == 2)
                                            ? Colors.green
                                            : Colors.green.withOpacity(0)),
                                    color: true
                                        ? const Color(0xFFC4C4C4)
                                        : Colors.red.withOpacity(0),
                                  ),
                                  height: 120,
                                  width: 120,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Image.asset(
                                        "${imagePath}userType_trainee.png",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "As a",
                                style: TextStyle(
                                  color: const Color(0xFF6CAE97),
                                  fontSize: ScreenUtil().setSp(
                                    10,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "TRAINEE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(
                                    10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        chooseNumber = 3;
                        userType = "trainer";
                      });
                    },
                    child: Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xFF373737),
                              ),
                              height: 152,
                              width: 141,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        width: 2,
                                        color: (chooseNumber == 3)
                                            ? Colors.green
                                            : Colors.green.withOpacity(0)),
                                    color: true
                                        ? const Color(0xFFC4C4C4)
                                        : Colors.red.withOpacity(0),
                                  ),
                                  height: 120,
                                  width: 120,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Image.asset(
                                        "${imagePath}userType_trainer.png",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "As a",
                                style: TextStyle(
                                  color: const Color(0xFF6CAE97),
                                  fontSize: ScreenUtil().setSp(
                                    10,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "TRAINER",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(
                                    10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width / (844 / 200),
              ),
              (chooseNumber == 2 || chooseNumber == 3)
                  ? SportAppRoundedButton(
                inputText: "CONFIRM",
                heightRatio: (844 / 60),
                widthRatio: (390 / 154),
                buttonColor: yellowColor,
                textStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(
                      16,
                    ),
                    color: Colors.black),
                borderColor: yellowColor,
                customOnPressed: () {
                  setUserType(userType);
                  navigateToAvatarPage(context, false);
                },
              )
                  : SportAppRoundedButton(
                inputText: "CONFIRM",
                heightRatio: (844 / 60),
                widthRatio: (390 / 154),
                buttonColor: Colors.grey,
                textStyle:
                const TextStyle(fontSize: 16, color: Colors.black),
                borderColor: Colors.grey,
                customOnPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  setUserType(String userType) async {
    User user = FirebaseAuth.instance.currentUser!;
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {
          'usertype': userType,
        },
      );
    } catch (e) {
      dev.log(e.toString());
    }
  }
}
