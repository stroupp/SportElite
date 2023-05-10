import 'dart:developer' as dev;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sport_elite_app/profile_screen/entity/profile_info_entity.dart';
import 'package:sport_elite_app/profile_screen/interactor/profile_edit_interactor.dart';
import 'package:sport_elite_app/profile_screen/view/profile_editing.dart';
import 'package:sport_elite_app/widgets/sport_app_rounded_button.dart';
import '../../chat_screen/view/chat_screen_view.dart';
import '../../dashboard/dashboard_presenter.dart';
import '../../dashboard/entity/offer.dart';
import '../../dashboard/trainer_view/dashboard_add_trainee_view.dart';
import '../../home_screen/interactor/home_screen_interactor.dart';
import '../../messaging_screen/entity/user.dart';
import '../../utils/constants.dart';
import '../../utils/localization_en.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  final String username;
  final bool isVisitor;

  const ProfilePage(
      {Key? key,
      required this.uid,
      required this.username,
      required this.isVisitor})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<ProfileInfo>> futureInfo;
  ProfileEditInteractor profileEditInteractor = ProfileEditInteractor();
  DashboardPresenter dashboardPresenter = DashboardPresenter();
  TextEditingController programName = TextEditingController();

  DateTime _dateTime = DateTime.now();

  final _dateTimeController = TextEditingController();

  Future<String> getUserAvatarUrl(String? uid) async {
    return await HomeScreenInteractor.getPpUrlOfUser(uid!);
  }

  @override
  void initState() {
    _dateTimeController.text =
        DateFormat('yyyy-MM-dd – kk:mm').format(_dateTime);
    super.initState();
  }

  Future<DateTime?> pickDate() async {
    return showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(MAX_DATE_YEAR_SPAN),
    );
  }

  Future<TimeOfDay?> pickTime() async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    // User pressed on 'Cancel'
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    // User pressed on 'Cancel'
    if (time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(
      () {
        _dateTime = dateTime;
        _dateTimeController.text =
            DateFormat('yyyy-MM-dd – kk:mm').format(_dateTime);
        dev.log('[DASHBOARD] dateTime: ${_dateTimeController.text}}');
      },
    );
  }

  Future<String> getUsername() async {
    User user = FirebaseAuth.instance.currentUser!;
    return (await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get())
        .get("username");
  }

  Future<String> getUserType() async {
    User user = FirebaseAuth.instance.currentUser!;
    return (await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get())
        .get("usertype");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            "${imagePath}back_button.svg",
          ),
          iconSize: 24,
          onPressed: () {
            Navigator.pop(context);
            dev.log("[Profile Page] pressed on back button");
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .where("uid",
                isEqualTo: widget.isVisitor
                    ? widget.uid
                    : FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.black,
                            height: MediaQuery.of(context).size.height *
                                225 /
                                testScreenHeight,
                            width: double.infinity,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            child: widget.isVisitor
                                ? Text(
                                    snapshot.data?.docs[0].get("username"),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(18),
                                    ),
                                  )
                                : FutureBuilder(
                                    future: getUsername(),
                                    builder: (context,
                                        AsyncSnapshot<String> snapshot) {
                                      return Text(
                                        snapshot.data ?? "No username",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(18),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height *
                                50 /
                                testScreenHeight,
                            width: testScreenWidth,
                            child: widget.isVisitor
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SportAppRoundedButton(
                                          inputText: "Schedule",
                                          heightRatio: (testScreenHeight / 40),
                                          widthRatio: (testScreenWidth / 245),
                                          buttonColor: yellowColor,
                                          textStyle: TextStyle(
                                              fontSize: ScreenUtil().setSp(14),
                                              color: Colors.black),
                                          borderColor: yellowColor),
                                      FutureBuilder(
                                        future: getUserType(),
                                        builder: (context, snapshotUserType) {
                                          if (snapshotUserType.data ==
                                                  "trainer" &&
                                              snapshot.data?.docs[0]
                                                      .get("usertype") ==
                                                  "trainee") {
                                            return IconButton(
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: const Text(
                                                        "Choose a date and time"),
                                                    content: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "Username : ${snapshot.data?.docs[0].get("username")}"),
                                                        Text(
                                                            "Mail Address : ${snapshot.data?.docs[0].get("email")}"),
                                                        TextFormField(
                                                          controller:
                                                              programName,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          16),
                                                              color:
                                                                  Colors.black),
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            enabledBorder:
                                                                const UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .grey),
                                                            ),
                                                            labelText:
                                                                "Program Name",
                                                            labelStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          16),
                                                            ),
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          validator:
                                                              (dateValidator) {
                                                            if (dateValidator ==
                                                                    null ||
                                                                dateValidator
                                                                    .isEmpty) {
                                                              return dashboardInputDateEmptyTextField;
                                                            }
                                                            return null;
                                                          },
                                                          controller:
                                                              _dateTimeController,
                                                          cursorColor:
                                                              dashboardAddTraineeHighlightGreenColor,
                                                          onTap: pickDateTime,
                                                          decoration:
                                                              InputDecoration(
                                                            enabledBorder:
                                                                const UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color:
                                                                    dashboardAddTraineeInputFieldHintGreyColor,
                                                                width: 2,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                  15,
                                                                ),
                                                              ),
                                                            ),
                                                            focusedBorder:
                                                                const UnderlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color:
                                                                    dashboardAddTraineeHighlightGreenColor,
                                                                width: 2,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                  15,
                                                                ),
                                                              ),
                                                            ),
                                                            icon: const Icon(
                                                              Icons
                                                                  .calendar_today,
                                                              color:
                                                                  dashboardAddTraineeHighlightGreenColor,
                                                            ),
                                                            // icon of text field
                                                            label: Text(
                                                              "Enter date and time",
                                                              style: TextStyle(
                                                                fontSize:
                                                                    ScreenUtil()
                                                                        .setSp(
                                                                  14,
                                                                ),
                                                                color:
                                                                    dashboardAddTraineeInputFieldHintGreyColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
                                                          ),
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          // Find trainee to send offer
                                                          var traineeUID =
                                                              await dashboardPresenter
                                                                  .onfindTraineeByEmail(
                                                                      snapshot
                                                                          .data
                                                                          ?.docs[
                                                                              0]
                                                                          .get(
                                                                              "email"))
                                                                  .then(
                                                            (value) {
                                                              if (value ==
                                                                  null) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                    content:
                                                                        Text(
                                                                      dashboardAddTraineeNoUserFound,
                                                                    ),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                );
                                                                return;
                                                              }
                                                              return value;
                                                            },
                                                          ).onError(
                                                            (error,
                                                                stackTrace) {
                                                              dev.log(
                                                                "[DASHBOARD ADD TRAINEE VIEW] Find Trainee by Email Error:",
                                                                error: error,
                                                                stackTrace:
                                                                    stackTrace,
                                                              );
                                                              return;
                                                            },
                                                          );

                                                          // no trainee found, show a error message
                                                          var trainerId =
                                                              dashboardPresenter
                                                                  .getCurrentFirebaseUser()!
                                                                  .uid;

                                                          // create a map to load the offer
                                                          var traineeRegistrationOffer =
                                                              TraineeeRegistrationOffer(
                                                            snapshot
                                                                .data?.docs[0]
                                                                .get(
                                                                    "username"),
                                                            snapshot
                                                                .data?.docs[0]
                                                                .get(
                                                                    "username"),
                                                            "phone",
                                                            programName.text,
                                                            false,
                                                            trainerId,
                                                            _dateTimeController
                                                                .text,
                                                          ).toJson();

                                                          if (traineeUID ==
                                                              null) {
                                                            dev.log(
                                                                "[DASHBOARD ADD TRAINEE VIEW] Trainee UID is null");
                                                            return;
                                                          }

                                                          await dashboardPresenter
                                                              .onWriteOfferToTrainee(
                                                            traineeUID,
                                                            traineeRegistrationOffer,
                                                          )
                                                              .then(
                                                            (value) {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  duration: Duration(seconds: 2),
                                                                  content: Text(
                                                                    "Offer sent successfully",
                                                                  ),
                                                                ),
                                                              );
                                                              dev.log(
                                                                "[DASHBOARD ADD TRAINEE VIEW] Offer sent successfully",
                                                              );
                                                              return;
                                                            },
                                                          ).onError(
                                                            (error,
                                                                stackTrace) {
                                                              dev.log(
                                                                "[DASHBOARD ADD TRAINEE VIEW]: Write Offer to Trainee Error:",
                                                                error: error,
                                                                stackTrace:
                                                                    stackTrace,
                                                              );
                                                              return;
                                                            },
                                                          );
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            "Send The Request"),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.add,
                                                color: yellowColor,
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          var userData = UserData(
                                            uid: snapshot.data?.docs[0]
                                                .get("uid"),
                                            email: snapshot.data?.docs[0]
                                                .get("email"),
                                            username: snapshot.data?.docs[0]
                                                .get("username"),
                                          );

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatScreen(userData),
                                            ),
                                          ).then(
                                            (value) {
                                              dev.log(
                                                  "[DashboardTraineeListView] Navigated user ${snapshot.data?.docs[0].get("uid")} with email ${snapshot.data?.docs[0].get("email")} successfully");
                                            },
                                          );
                                        },
                                        icon: SvgPicture.asset(
                                          "${imagePath}message_icon.svg",
                                        ),
                                      ),
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    child: SportAppRoundedButton(
                                        inputText: "Edit Profile",
                                        heightRatio: (testScreenHeight / 40),
                                        widthRatio: (testScreenWidth / 245),
                                        buttonColor: yellowColor,
                                        customOnPressed: () async =>
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ProfileEdit(),
                                              ),
                                            ),
                                        textStyle: TextStyle(
                                            fontSize: ScreenUtil().setSp(14),
                                            color: Colors.black),
                                        borderColor: yellowColor),
                                  ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                color: const Color(0xFF707070),
                                height: MediaQuery.of(context).size.height *
                                    2 /
                                    testScreenHeight,
                                width: MediaQuery.of(context).size.width *
                                    364 /
                                    testScreenWidth,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      "About Me",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(14),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              12 /
                                              testScreenHeight,
                                    ),
                                    snapshot.data?.docs[0].get("aboutMe") == ""
                                        ? AutoSizeText(
                                            "The user hasn't written anything here",
                                            style: TextStyle(
                                              color: yellowColor,
                                              fontSize: ScreenUtil().setSp(14),
                                            ),
                                          )
                                        : AutoSizeText(
                                            snapshot.data?.docs[0]
                                                .get("aboutMe"),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(
                                                14,
                                              ),
                                            )),
                                  ],
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    color: const Color(0xFF707070),
                                    height: MediaQuery.of(context).size.height *
                                        2 /
                                        testScreenHeight,
                                    width: MediaQuery.of(context).size.width *
                                        364 /
                                        testScreenWidth,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      "Interests",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(
                                            14,
                                          ),
                                          fontFamily: 'Poppins'),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              12 /
                                              testScreenHeight,
                                    ),
                                    snapshot.data?.docs[0].get("interests") ==
                                            ""
                                        ? AutoSizeText(
                                            "The user hasn't written anything here",
                                            style: TextStyle(
                                              color: yellowColor,
                                              fontSize: ScreenUtil().setSp(14),
                                            ),
                                          )
                                        : AutoSizeText(
                                            snapshot.data?.docs[0]
                                                .get("interests"),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(14),
                                            ),
                                          )
                                  ],
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    color: const Color(0xFF707070),
                                    height: MediaQuery.of(context).size.height *
                                        2 /
                                        testScreenHeight,
                                    width: MediaQuery.of(context).size.width *
                                        364 /
                                        testScreenWidth,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ExpandablePanel(
                                      header: AutoSizeText(
                                        "Work and Education",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(14),
                                            fontFamily: 'Poppins'),
                                      ),
                                      collapsed: Container(),
                                      expanded: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                "University",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                    fontFamily: 'Poppins'),
                                              ),
                                              snapshot.data?.docs[0]
                                                          .get("university") ==
                                                      ""
                                                  ? AutoSizeText(
                                                      "No data",
                                                      style: TextStyle(
                                                        color: yellowColor,
                                                        fontSize:
                                                            ScreenUtil().setSp(
                                                          14,
                                                        ),
                                                      ),
                                                    )
                                                  : AutoSizeText(
                                                      snapshot.data?.docs[0]
                                                          .get("university"),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: ScreenUtil()
                                                            .setSp(14),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                12 /
                                                testScreenHeight,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                "Speciality",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                    fontFamily: 'Poppins'),
                                              ),
                                              snapshot.data?.docs[0]
                                                          .get("speciality") ==
                                                      ""
                                                  ? AutoSizeText(
                                                      "No data",
                                                      style: TextStyle(
                                                        color: yellowColor,
                                                        fontSize: ScreenUtil()
                                                            .setSp(14),
                                                      ),
                                                    )
                                                  : AutoSizeText(
                                                      snapshot.data?.docs[0]
                                                          .get("speciality"),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: ScreenUtil()
                                                            .setSp(14),
                                                      ),
                                                    )
                                            ],
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                12 /
                                                testScreenHeight,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                "Company",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                    fontFamily: 'Poppins'),
                                              ),
                                              snapshot.data?.docs[0]
                                                          .get("company") ==
                                                      ""
                                                  ? AutoSizeText(
                                                      "No data",
                                                      style: TextStyle(
                                                        color: yellowColor,
                                                        fontSize: ScreenUtil()
                                                            .setSp(14),
                                                      ),
                                                    )
                                                  : AutoSizeText(
                                                      snapshot.data?.docs[0]
                                                          .get("company"),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: ScreenUtil()
                                                            .setSp(14),
                                                      ),
                                                    )
                                            ],
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                12 /
                                                testScreenHeight,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                "Position",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                    fontFamily: 'Poppins'),
                                              ),
                                              AutoSizeText(
                                                snapshot.data?.docs[0]
                                                    .get("usertype"),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: ScreenUtil().setSp(
                                                    14,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      theme: const ExpandableThemeData(
                                          iconColor: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height *
                            120 /
                            testScreenHeight,
                        left: MediaQuery.of(context).size.width *
                            30 /
                            testScreenWidth,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          height: 100,
                          width: 100,
                          child: FutureBuilder(
                            future: getUserAvatarUrl(widget.isVisitor
                                ? snapshot.data?.docs[0].get("uid")
                                : FirebaseAuth.instance.currentUser!.uid),
                            builder:
                                (context, AsyncSnapshot<String> ppSnapshot) {
                              if (!ppSnapshot.hasData) {
                                return const Text(
                                  'No avatar picture found',
                                  style: TextStyle(
                                    color: messagingTitleWhiteColor,
                                  ),
                                );
                              }
                              return Image.network(ppSnapshot.data!);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
