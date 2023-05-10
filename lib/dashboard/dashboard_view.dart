import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sport_elite_app/dashboard/dashboard_menu.dart';
import 'package:sport_elite_app/dashboard/dashboard_presenter.dart';
import 'package:sport_elite_app/utils/constants.dart';

import '../chat_screen/view/chat_screen_view.dart';
import '../messaging_screen/entity/user.dart';
import '../utils/constants.dart';
import '../utils/localization_en.dart';
import 'trainee_view/dashboard_trainer_list_view.dart';
import 'trainer_view/dashboard_trainee_list_view.dart';

final ZoomDrawerController zoomDrawerController = ZoomDrawerController();

class DashboardWithDrawer extends StatefulWidget {
  const DashboardWithDrawer({Key? key}) : super(key: key);

  @override
  _DashboardWithDrawerState createState() => _DashboardWithDrawerState();
}

class _DashboardWithDrawerState extends State<DashboardWithDrawer> {
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: zoomDrawerController,
      style: DrawerStyle.defaultStyle,
      moveMenuScreen: false,
      openCurve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 400),
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      mainScreen: const DashboardView(),
      menuScreen: SafeArea(
        child: Theme(data: ThemeData.dark(), child: const DashboardMenu()),
      ),
    );
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final _dashboardPresenter = DashboardPresenter();

  DashboardPresenter get dashboardPresenter => _dashboardPresenter;

  final _firestoreUsernameLiteral = "username";

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const DashboardWithDrawer(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    });
    _refreshController.refreshCompleted();
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
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            content: const Text(
              'Do you want to exit?',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: const Text(
                  "No",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => SystemNavigator.pop(),
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
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

  void initState() {
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    const Color background = Colors.white;
    const Color fill = Color(0xffEFEFEF);
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    const double fillPercent = 40; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 150 / testScreenWidth,
              left: MediaQuery.of(context).padding.left * 20 / testScreenWidth,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  alignment: Alignment.topLeft,
                  fit: BoxFit.fill,
                  child: Text(
                    dashboardAppbarTitle,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(
                        22,
                      ),
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: _dashboardPresenter.getFirebaseUsername(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                          dashboardMenu_noUserFound,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          dashboardMenu_onUserError,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }
                    var userData = snapshot.data;
                    return FittedBox(
                      fit: BoxFit.fill,
                      child: Text(
                        userData[_firestoreUsernameLiteral],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(
                            20,
                          ),
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: dashboardAppbarYellow,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          toolbarHeight:
              MediaQuery.of(context).size.height * 187 / testScreenHeight,
          actions: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.height *
                      85 /
                      testScreenHeight,
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    '${imagePath}dashboard_menu_btn.svg',
                    height: 100,
                  ),
                  onPressed: () {
                    zoomDrawerController.toggle!();
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.height *
                      26 /
                      testScreenHeight,
                ),
              ],
            ),
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          enablePullDown: true,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      12 /
                      testScreenHeight,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 10,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      dashboardListViewNextProgramText,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(
                          18,
                        ),
                        color: dashboardWhiteColor,
                      ),
                    ),
                  ),
                ),
                FutureBuilder(
                  future: dashboardPresenter.getCurrentUserType(),
                  builder: (BuildContext context,
                      AsyncSnapshot currentUserSnapshot) {
                    if (!currentUserSnapshot.hasData) {
                      return const Text(
                        'No user type found',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: messagingTitleWhiteColor,
                        ),
                      );
                    } else if (currentUserSnapshot.data == null) {
                      return const Text(
                        'Null user type',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: messagingTitleWhiteColor,
                        ),
                      );
                    } else if (currentUserSnapshot.hasError) {
                      return Text(
                        'Error: ${currentUserSnapshot.error}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: messagingTitleWhiteColor,
                        ),
                      );
                    } else if (currentUserSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    var traineeLiteral = "trainee";
                    var trainerLiteral = "trainer";

                    return FutureBuilder(
                      future: currentUserSnapshot.data == null
                          ? Future.error("Null Future")
                          : currentUserSnapshot.data == traineeLiteral
                              ? dashboardPresenter.onGetTraineeNextProgram()
                              : dashboardPresenter.onGetTrainerNextProgram(),
                      builder: (BuildContext context,
                          AsyncSnapshot programSnapshot) {
                        if (!programSnapshot.hasData) {
                          return const Text(
                            'No next program found',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: messagingTitleWhiteColor,
                            ),
                          );
                        } else if (programSnapshot.data == null) {
                          return const Text(
                            'Null next program',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: messagingTitleWhiteColor,
                            ),
                          );
                        } else if (programSnapshot.hasError) {
                          return Text(
                            'Error: ${currentUserSnapshot.error}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: messagingTitleWhiteColor,
                            ),
                          );
                        } else if (programSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        // Program Data
                        var programData = programSnapshot.data;

                        // Trainee Firebase fields
                        var programNameLiteral = "name";
                        var programDateLiteral = "date";
                        var programTrainerLiteral = "trainer";

                        // Trainer Firebase fields
                        var trainerUsernameLiteral = "username";
                        var trainersTraineeUsernameLiteral = "traineeUsername";
                        var trainerProgramDescriptionLiteral = "programName";
                        var trainerProgramDateLiteral = "programDate";

                        var trainerProgramDate =
                            programData[programDateLiteral];

                        var trimmedProgramDate =
                            trainerProgramDate.toString().replaceAll("–", "");

                        return GestureDetector(
                          onTap: () async {
                            // Current User is Trainee
                            if (currentUserSnapshot.data == traineeLiteral) {
                              await dashboardPresenter
                                  .onGetUserInfo(
                                      programData[programTrainerLiteral])
                                  .then(
                                (value) {
                                  var trainerUIDLiteral = "uid";
                                  var trainerUsernameLiteral = "username";

                                  var chatScreenTrainerNavigationData =
                                      UserData(
                                    uid: value[trainerUIDLiteral],
                                    email: value[trainerUsernameLiteral],
                                    username: value[trainerUsernameLiteral],
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                          chatScreenTrainerNavigationData),
                                    ),
                                  );
                                },
                              );
                              return;
                            }
                            // Current User is Trainer
                            if (currentUserSnapshot.data == trainerLiteral) {
                              dashboardPresenter
                                  .onfindTraineeByEmail(programData[
                                      trainersTraineeUsernameLiteral])
                                  .then(
                                (traineeUID) async {
                                  await dashboardPresenter
                                      .onGetUserInfo(traineeUID)
                                      .then(
                                    (traineeData) {
                                      var traineeUsernameLiteral = "username";
                                      var traineeEmailLiteral = "email";

                                      var chatScreenTraineeNavigationData =
                                          UserData(
                                        uid: traineeUID,
                                        email: traineeData[traineeEmailLiteral],
                                        username:
                                            traineeData[traineeUsernameLiteral],
                                      );

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                              chatScreenTraineeNavigationData),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                              return;
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 15,
                            ),
                            height: MediaQuery.of(context).size.height /
                                (testScreenHeight / 150),
                            width: MediaQuery.of(context).size.width /
                                (testScreenWidth / 350),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: gradient,
                                stops: stops,
                                end: Alignment.bottomCenter,
                                begin: Alignment.topCenter,
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          20 /
                                          testScreenWidth,
                                      right: MediaQuery.of(context).size.width *
                                          20 /
                                          testScreenWidth,
                                      top: MediaQuery.of(context).size.height *
                                          20 /
                                          testScreenHeight,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              5 /
                                              testScreenHeight,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: Icon(
                                              Icons.access_alarm_outlined,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  50 /
                                                  testScreenHeight,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                30 /
                                                testScreenWidth,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 10,
                                          //fit: FlexFit.loose,
                                          child: AutoSizeText(
                                            "${currentUserSnapshot.data == null ? "" : currentUserSnapshot.data == traineeLiteral ? programData[programNameLiteral] : programData[trainerProgramDescriptionLiteral]}",
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(
                                                18,
                                              ),
                                              color:
                                                  dashboardNextProgramTitleColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                6 /
                                                testScreenWidth,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          //fit: FlexFit.loose,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              "in",
                                              style: TextStyle(
                                                fontSize: ScreenUtil().setSp(
                                                  14,
                                                ),
                                                color:
                                                    dashboardNextProgramLocationPrepositionColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                12 /
                                                testScreenWidth,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          //fit: FlexFit.loose,

                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text(
                                              "SO3",
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontSize: ScreenUtil().setSp(
                                                  17,
                                                ),
                                                color:
                                                    dashboardNextProgramLocationColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                30 /
                                                testScreenWidth,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          //fit: FlexFit.tight,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.more_vert_outlined,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                21 /
                                                testScreenWidth,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          20 /
                                          testScreenWidth,
                                      right: MediaQuery.of(context).size.width *
                                          20 /
                                          testScreenWidth,
                                      top: MediaQuery.of(context).size.height *
                                          20 /
                                          testScreenHeight,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              5 /
                                              testScreenHeight,
                                    ),
                                    child: Row(
                                      children: [
                                        const Expanded(
                                          flex: 1,
                                          //fit: FlexFit.loose,
                                          child: Icon(
                                            Icons.calendar_today_outlined,
                                            color:
                                                dashboardNextProgramDateColor,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          //fit: FlexFit.loose,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                (0.5 / testScreenWidth),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          //fit: FlexFit.loose,
                                          child: Text(
                                            "${currentUserSnapshot.data == traineeLiteral ? trimmedProgramDate : programData[trainerProgramDateLiteral]}",
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(11),
                                              color:
                                                  dashboardNextProgramDateColor,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          //fit: FlexFit.loose,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                21 /
                                                testScreenWidth,
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 2,
                                          //fit: FlexFit.loose,
                                          child: Icon(
                                            Icons.person_outline_outlined,
                                            color:
                                                dashboardNextProgramPersonTextColor,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: FutureBuilder(
                                            future: currentUserSnapshot.data ==
                                                    traineeLiteral
                                                ? dashboardPresenter
                                                    .onGetUserInfo(programSnapshot
                                                            .data[
                                                        programTrainerLiteral])
                                                : dashboardPresenter
                                                    .onGetTrainerNextProgram(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot userSnapshot) {
                                              if (!userSnapshot.hasData) {
                                                return Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  userSnapshot.data !=
                                                          traineeLiteral
                                                      ? 'No trainee found'
                                                      : 'No trainer found',
                                                  style: const TextStyle(
                                                    color:
                                                        dashboardNextProgramPersonTextColor,
                                                  ),
                                                );
                                              } else if (userSnapshot.data ==
                                                  null) {
                                                return Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  userSnapshot.data !=
                                                          traineeLiteral
                                                      ? 'Null trainee'
                                                      : 'Null trainer',
                                                  style: const TextStyle(
                                                    color:
                                                        dashboardNextProgramPersonTextColor,
                                                  ),
                                                );
                                              } else if (userSnapshot
                                                  .hasError) {
                                                return Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  'Error: ${currentUserSnapshot.error}',
                                                  style: const TextStyle(
                                                    color:
                                                        dashboardNextProgramPersonTextColor,
                                                  ),
                                                );
                                              } else if (userSnapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              // Trainer Data
                                              var trainerData =
                                                  userSnapshot.data;

                                              return Text(
                                                "${currentUserSnapshot.data == traineeLiteral ? trainerData[trainerUsernameLiteral] : programData[trainersTraineeUsernameLiteral]}",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(11),
                                                  color:
                                                      dashboardNextProgramPersonTextColor,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                textAlign: TextAlign.start,
                                              );
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          //fit: FlexFit.loose,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                24 /
                                                testScreenWidth,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: dashboardPresenter.getCurrentUserType(),
                    builder: (BuildContext context,
                        AsyncSnapshot currentUserSnapshot) {
                      if (!currentUserSnapshot.hasData) {
                        return const Text(
                          'No user type found',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: messagingTitleWhiteColor,
                          ),
                        );
                      } else if (currentUserSnapshot.data == null) {
                        return const Text(
                          'Null user type',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: messagingTitleWhiteColor,
                          ),
                        );
                      } else if (currentUserSnapshot.hasError) {
                        return Text(
                          'Error: ${currentUserSnapshot.error}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: messagingTitleWhiteColor,
                          ),
                        );
                      } else if (currentUserSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      var traineeLiteral = "trainee";
                      var trainerLiteral = "trainer";
                      if (currentUserSnapshot.data == traineeLiteral) {
                        return const DashboardTrainerListView();
                      }
                      if (currentUserSnapshot.data == trainerLiteral) {
                        return const DashboardTraineeListView();
                      }

                      return const Center(
                          child: Text(
                        "No list view found",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
