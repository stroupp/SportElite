import 'dart:developer' as dev;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sport_elite_app/dashboard/dashboard_view.dart';
import 'package:sport_elite_app/dashboard/trainer_view/dashboard_add_trainee_view.dart';
import 'package:sport_elite_app/router/router.dart';
import 'package:sport_elite_app/search_by_name/view/search_by_name_view.dart';
import '../messaging_screen/messaging_view.dart';
import '../utils/constants.dart';
import '../utils/localization_en.dart';
import 'dashboard_presenter.dart';

class DashboardMenu extends StatefulWidget {
  const DashboardMenu({Key? key}) : super(key: key);

  @override
  State<DashboardMenu> createState() => _DashboardMenuState();
}

class _DashboardMenuState extends State<DashboardMenu> {
  final _dashboardPresenter = DashboardPresenter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height:
                MediaQuery.of(context).size.height * 67.7 / testScreenHeight,
          ),
          GestureDetector(
            onTap: () {
              zoomDrawerController.toggle!();
            },
            child: Align(
              alignment: const Alignment(
                -0.6,
                0.7,
              ),
              child: SvgPicture.asset(
                "${imagePath}Layer 4.svg",
                height:
                    MediaQuery.of(context).size.height * 68 / testScreenHeight,
                width: 65,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              zoomDrawerController.toggle!();
            },
            child: Align(
              alignment: const Alignment(
                0.12,
                1,
              ),
              child: SizedBox(
                height:
                    MediaQuery.of(context).size.height * 88 / testScreenHeight,
                width: MediaQuery.of(context).size.width * 95 / testScreenWidth,
                child: AutoSizeText(
                  textAlign: TextAlign.center,
                  dashboardMenu_title,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(33),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 170 / testScreenHeight,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: FutureBuilder(
              future: _dashboardPresenter.getCurrentUserType(),
              builder: (BuildContext context, AsyncSnapshot usertypeSnapshot) {
                if (!usertypeSnapshot.hasData) {
                  return const Text(
                    'No user type found',
                    style: TextStyle(
                      color: messagingTitleWhiteColor,
                    ),
                  );
                } else if (usertypeSnapshot.data == null) {
                  return const Text(
                    'Null user type',
                    style: TextStyle(
                      color: messagingTitleWhiteColor,
                    ),
                  );
                } else if (usertypeSnapshot.hasError) {
                  return Text(
                    'Error: ${usertypeSnapshot.error}',
                    style: const TextStyle(
                      color: messagingTitleWhiteColor,
                    ),
                  );
                } else if (usertypeSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: yellowColor),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        //TODO: navigate the parameters to the profile page
                        navigateToProfilePage(
                            context, "123456", "Yakup Can Avcı", false);
                        dev.log("[Dashboard] pressed on my profile");
                      },
                      child: Container(
                        transform: Matrix4.translationValues(
                          -70,
                          0,
                          0,
                        ),
                        height: MediaQuery.of(context).size.height *
                            51 /
                            testScreenHeight,
                        width: MediaQuery.of(context).size.width *
                            300 /
                            testScreenWidth,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "${imagePath}dashboard_menu_btnHover.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(
                              23,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width *
                                12 /
                                testScreenWidth,
                            left: MediaQuery.of(context).size.width *
                                90 /
                                testScreenWidth,
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 6,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: AutoSizeText(
                                    dashboardMenu_myProfile_btn_title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(
                                        17,
                                      ),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      12.5 /
                                      testScreenWidth,
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: SvgPicture.asset(
                                  "${imagePath}dashboard_Menu_myProfile_icon.svg",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          25 /
                          testScreenHeight,
                    ),
                    GestureDetector(
                      onTap: () {
                        dev.log("[Dashboard] pressed on log out student");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MessagingView(),
                          ),
                        );
                      },
                      child: Container(
                        transform: Matrix4.translationValues(
                          -18,
                          0,
                          0,
                        ),
                        height: MediaQuery.of(context).size.height *
                            51 /
                            testScreenHeight,
                        width: MediaQuery.of(context).size.width *
                            400 /
                            testScreenHeight,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "${imagePath}dashboard_menu_btnHover.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(
                              23,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width *
                                12 /
                                testScreenWidth,
                            left: MediaQuery.of(context).size.width *
                                25 /
                                testScreenWidth,
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      10 /
                                      testScreenWidth,
                                ),
                              ),
                              Flexible(
                                flex: 6,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: AutoSizeText(
                                    "Messages",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(
                                        16,
                                      ),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      16 /
                                      testScreenWidth,
                                ),
                              ),
                              const Flexible(
                                flex: 2,
                                child: Icon(
                                  Icons.message,
                                  color: yellowColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          25 /
                          testScreenHeight,
                    ),
                    GestureDetector(
                      onTap: () {
                        dev.log("[Dashboard] pressed on search by name");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SearchByName(
                                userType: usertypeSnapshot.data,
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        transform: Matrix4.translationValues(
                          -35,
                          0,
                          0,
                        ),
                        height: MediaQuery.of(context).size.height *
                            51 /
                            testScreenHeight,
                        width: MediaQuery.of(context).size.width *
                            330 /
                            testScreenWidth,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "${imagePath}dashboard_menu_btnHover.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(
                              23,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width *
                                12 /
                                testScreenWidth,
                            left: MediaQuery.of(context).size.width *
                                50 /
                                testScreenWidth,
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 9,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: AutoSizeText(
                                    (usertypeSnapshot.data == "trainer")
                                        ? dashboardMenu_searchBy_btn_title
                                        : dashboardMenu_searchFor_btn_title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(
                                        17,
                                      ),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      12.5 /
                                      testScreenWidth,
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Image.asset(
                                  "${imagePath}dashboard_menu_searchBy_icon.png",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          25 /
                          testScreenHeight,
                    ),
                    (usertypeSnapshot.data == "trainer")
                        ? GestureDetector(
                            onTap: () {
                              dev.log(
                                  "[Dashboard] pressed on register student");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const DashboardAddTraineeView();
                                  },
                                ),
                              );
                            },
                            child: Container(
                              transform: Matrix4.translationValues(
                                -18,
                                0,
                                0,
                              ),
                              height: MediaQuery.of(context).size.height *
                                  51 /
                                  testScreenHeight,
                              width: MediaQuery.of(context).size.width *
                                  550 /
                                  testScreenHeight,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    "${imagePath}dashboard_menu_btnHover.png",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(
                                    23,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: MediaQuery.of(context).size.width *
                                      12 /
                                      testScreenWidth,
                                  left: MediaQuery.of(context).size.width *
                                      30 /
                                      testScreenWidth,
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 8,
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: AutoSizeText(
                                          dashboardMenu_addNewTrainee_btn_title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(
                                              17,
                                            ),
                                            fontWeight: FontWeight.normal,
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                20 /
                                                testScreenWidth,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: SvgPicture.asset(
                                        "${imagePath}dashboard_menu_register_icon.svg",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          100 /
                          testScreenHeight,
                    ),
                    GestureDetector(
                      onTap: () {
                        dev.log("[Dashboard] pressed on log out student");
                        _dashboardPresenter.signOut(context);
                      },
                      child: Container(
                        transform: Matrix4.translationValues(
                          -15,
                          0,
                          0,
                        ),
                        height: MediaQuery.of(context).size.height *
                            51 /
                            testScreenHeight,
                        width: MediaQuery.of(context).size.width *
                            250 /
                            testScreenHeight,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "${imagePath}dashboard_menu_btnHover.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(
                              23,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width *
                                12 /
                                testScreenWidth,
                            left: MediaQuery.of(context).size.width *
                                25 /
                                testScreenWidth,
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: Image.asset(
                                  "${imagePath}dashboard_menu_logoutButton_icon.png",
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      10 /
                                      testScreenWidth,
                                ),
                              ),
                              Flexible(
                                flex: 6,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: AutoSizeText(
                                    dashboardNenu_logout_btn_title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(
                                        17,
                                      ),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
