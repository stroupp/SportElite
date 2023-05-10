import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sport_elite_app/authentication_screen/authentication_type/presenter/authentiction_type_presenter.dart';
import 'package:sport_elite_app/widgets/sport_app_icon_button.dart';
import '../../../router/router.dart';
import '../../../utils/constants.dart';
import '../../../utils/localization_en.dart';

class AuthenticationTypeScreen extends StatefulWidget {
  const AuthenticationTypeScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationTypeScreen> createState() =>
      _AuthenticationTypeScreenState();
}

class _AuthenticationTypeScreenState extends State<AuthenticationTypeScreen> {
  AuthenticationTypePresenter authenticationTypePresenter =
      AuthenticationTypePresenter();

  bool isAbsorbed = false;

  @override
  void initState() {
    isAbsorbed = false;
    super.initState();
  }

  Future<bool> _onBackPressed() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            backgroundColor: Colors.white,
            title: const Text(
              "Are you sure?",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            content: const Text('Do you want to exit?',
                style: TextStyle(color: Colors.black)),
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: const Text("No", style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => SystemNavigator.pop(),
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(
                width: 5,
                height: 25,
              )
            ],
          ),
        ) ??
        false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: AbsorbPointer(
        absorbing: isAbsorbed,
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 83.3,
                        right: 74.4,
                        left: 74.4,
                      ),
                      child: SvgPicture.asset(
                        "${imagePath}Layer 4.svg",
                        width: MediaQuery.of(context).size.width *
                            241.12 /
                            testScreenWidth,
                        height: MediaQuery.of(context).size.height *
                            225.37 /
                            testScreenHeight,
                      ),
                    ),
                    const SizedBox(
                      height: 42,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 96,
                        left: 96,
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        scene_watchAuthenticationTypeScreen_authenticationTypeScreen_title,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            28,
                          ),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 39.5,
                        right: 35.5,
                        left: 35.5,
                      ),
                      child: Column(
                        children: [
                          SportAppIconButton(
                            text: Text(
                              scene_signinWithMailNavigator_authenticationTypeScreen_button,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: const Color(0xFF000000),
                                fontSize: ScreenUtil().setSp(
                                  16,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            imagePath: "${imagePath}mail_icon.svg",
                            imageBottomInset: 18,
                            imageLeftInset: 24,
                            imageRightInset: 45,
                            imageTopInset: 18,
                            height: 50,
                            width: 318,
                            buttonColor: const Color(0xffffe241),
                            customOnPressed: () {
                              setState(() {
                                isAbsorbed = true;
                              });
                              Future.delayed(const Duration(seconds: 1))
                                  .then((value) {
                                setState(() {
                                  isAbsorbed = false;
                                });
                              });
                              navigateToLoginWithMailScreen(context);
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SportAppIconButton(
                            text: Text(
                              scene_signinWithFacebook_authenticationTypeScreen_button,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: const Color(0xffffffff),
                                fontSize: ScreenUtil().setSp(16),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            imagePath: "${imagePath}facebook_icon.svg",
                            imageBottomInset: 18,
                            imageLeftInset: 24,
                            imageRightInset: 27,
                            imageTopInset: 18,
                            height: 50,
                            width: 318,
                            buttonColor: const Color(0xff376aed),
                            customOnPressed: () {
                              setState(() {
                                isAbsorbed = true;
                              });
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      content: FutureBuilder(
                                        future: Future.wait({
                                          authenticationTypePresenter
                                              .facebookPresenter(context)
                                        }),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          return Container();
                                        },
                                      ),
                                    );
                                  });
                              setState(() {
                                isAbsorbed = false;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SportAppIconButton(
                            text: Text(
                              scene_signinWithGoogle_authenticationTypeScreen_button,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: const Color(0xff242424),
                                fontSize: ScreenUtil().setSp(
                                  16,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            imagePath: "${imagePath}iconGoogle.svg",
                            imageBottomInset: 18,
                            imageLeftInset: 24,
                            imageRightInset: 38,
                            imageTopInset: 18,
                            height: 50,
                            width: 318,
                            buttonColor: const Color(0xffffffff),
                            customOnPressed: () {
                              setState(() {
                                isAbsorbed = true;
                              });
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      content: FutureBuilder(
                                        future: Future.wait({
                                          authenticationTypePresenter
                                              .googlePresenter(context)
                                        }),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          return Container();
                                        },
                                      ),
                                    );
                                  });
                              setState(() {
                                isAbsorbed = false;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
