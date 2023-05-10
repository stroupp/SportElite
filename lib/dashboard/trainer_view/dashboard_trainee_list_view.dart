import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path/path.dart';
import 'package:sport_elite_app/dashboard/dashboard_empty_view.dart';
import 'package:sport_elite_app/dashboard/dashboard_presenter.dart';
import 'package:sport_elite_app/messaging_screen/entity/user.dart';
import 'package:sport_elite_app/utils/constants.dart';
import '../../chat_screen/view/chat_screen_view.dart';
import '../../utils/constants.dart';
import '../../utils/localization_en.dart';

class DashboardTraineeListView extends StatefulWidget {
  const DashboardTraineeListView({Key? key}) : super(key: key);

  @override
  State<DashboardTraineeListView> createState() =>
      _DashboardUserListViewState();
}

class _DashboardUserListViewState extends State<DashboardTraineeListView> {
  // MEMBERS
  final _dashboardPresenter = DashboardPresenter();

  // GETTERS
  DashboardPresenter get dashboardPresenter => _dashboardPresenter;

  // METHODS

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => super.widget));
      },
      color: Colors.white,
      backgroundColor: Colors.purple,
      strokeWidth: 5,
      child: StreamBuilder<QuerySnapshot>(
        stream: dashboardPresenter.onGetRegisteredTrainees(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                overflow: TextOverflow.ellipsis,
              ),
            );
          } else if (snapshot.data == null) {
            return const Center(
              child: Text(
                'No Registered Trainees',
                overflow: TextOverflow.ellipsis,
              ),
            );
          } else if (!snapshot.hasData) {
            return const DashboardEmptyView();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              var registeredTraineeId = snapshot.data!.docs[index].id;
              return FutureBuilder(
                future: dashboardPresenter.onGetUserInfo(registeredTraineeId),
                builder: (BuildContext context, AsyncSnapshot traineeSnapshot) {
                  if (traineeSnapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${traineeSnapshot.error}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  } else if (traineeSnapshot.data == null) {
                    return const Center(
                      child: Text(
                        'No trainee found',
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  } else if (traineeSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // CALCULATING THE NEXT PROGRAM FOR TRAINER
                  // Get all trainee data
                  var traineeData = traineeSnapshot.data;

                  // Get next program date from trainee data
                  var programDate = traineeData["currentProgram"]["date"];

                  // Parse date to calculate difference from now
                  var parsedProgramDate =
                      dashboardPresenter.parseProgramDate(programDate);

                  // Calculate difference from now
                  var programDateDifference = dashboardPresenter
                      .calculateProgramDateDifference(parsedProgramDate);

                  // Convert days to weeks
                  var programDateWeeks = dashboardPresenter
                      .convertDaysToWeeks(programDateDifference);

                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      right: 30.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        var userData = UserData(
                          uid: traineeData["uid"],
                          email: traineeData["email"],
                          username: traineeData["username"],
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(userData),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height *
                                10 /
                                testScreenHeight),
                        decoration: BoxDecoration(
                          color: dashboardUserListViewItemOnDismiss,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width *
                                20 /
                                testScreenWidth,
                          ),
                        ),
                        height: MediaQuery.of(context).size.height *
                            85 /
                            testScreenHeight,
                        width: MediaQuery.of(context).size.width *
                            300 /
                            testScreenWidth,
                        child: Slidable(
                          key: UniqueKey(),
                          endActionPane: ActionPane(
                            extentRatio: 0.3,
                            motion: const StretchMotion(),
                            dismissible: DismissiblePane(
                              onDismissed: () async {
                                await dashboardPresenter.onDeleteRegisteredTrainer(FirebaseAuth.instance.currentUser?.uid, registeredTraineeId);
                                await dashboardPresenter
                                    .onDeleteRegisteredTrainee(
                                  registeredTraineeId,
                                );
                              },
                            ),
                            children: [
                              SlidableAction(
                                flex: 1,
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      20 /
                                      testScreenHeight,
                                  bottom: MediaQuery.of(context).size.height *
                                      20 /
                                      testScreenHeight,
                                  right: MediaQuery.of(context).size.width *
                                      20 /
                                      testScreenWidth,
                                  left: MediaQuery.of(context).size.width *
                                      20 /
                                      testScreenWidth,
                                ),
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height *
                                      20 /
                                      testScreenHeight,
                                ),
                                onPressed: (_) async {
                                  await dashboardPresenter.onDeleteRegisteredTrainer(FirebaseAuth.instance.currentUser?.uid, registeredTraineeId);
                                  await dashboardPresenter
                                      .onDeleteRegisteredTrainee(
                                    registeredTraineeId,
                                  );
                                },
                                backgroundColor:
                                    dashboardUserListViewItemOnDismiss,
                                label:
                                    dashboardTraineeListViewDismissiableDeleteButtonText,
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width *
                                    20 /
                                    testScreenWidth,
                              ),
                            ),
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height *
                                90 /
                                testScreenHeight,
                            width: MediaQuery.of(context).size.width *
                                380 /
                                testScreenWidth,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          10 /
                                          testScreenWidth,
                                      right: MediaQuery.of(context).size.width *
                                          10 /
                                          testScreenWidth,
                                      top: MediaQuery.of(context).size.height *
                                          8 /
                                          testScreenHeight,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              8 /
                                              testScreenHeight,
                                    ),
                                    child: FutureBuilder<String>(
                                      future: dashboardPresenter
                                          .onGetUserAvatarUrl(
                                              traineeSnapshot.data["uid"])
                                          .onError(
                                        (error, stackTrace) {
                                          return "Unable to fetch avatar url";
                                        },
                                      ),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String>
                                              avatarPictureSnapshot) {
                                        if (!avatarPictureSnapshot.hasData) {
                                          return const Text(
                                            'No avatar picture found',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: messagingTitleWhiteColor,
                                            ),
                                          );
                                        } else if (avatarPictureSnapshot.data ==
                                            null) {
                                          return const Text(
                                            'No avatar picture found',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: messagingTitleWhiteColor,
                                            ),
                                          );
                                        } else if (avatarPictureSnapshot
                                            .hasError) {
                                          return Text(
                                            'Error: ${snapshot.error}',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: messagingTitleWhiteColor,
                                            ),
                                          );
                                        } else if (avatarPictureSnapshot
                                                .connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return FittedBox(
                                          fit: BoxFit.fill,
                                          child: CircleAvatar(
                                            backgroundImage: Image.network(
                                              avatarPictureSnapshot.data!,
                                              fit: BoxFit.cover,
                                            ).image,
                                            radius: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                40 /
                                                testScreenHeight,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 10,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          12 /
                                          testScreenHeight,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              12 /
                                              testScreenHeight,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "${traineeSnapshot.data["username"]}",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(
                                                15,
                                              ),
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "${traineeSnapshot.data["currentProgram"]["name"]}",
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(
                                                15,
                                              ),
                                              color:
                                                  dashboardUserListViewSubtitleGreyColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        10 /
                                        testScreenWidth,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              2 /
                                              testScreenHeight,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              15 /
                                              testScreenHeight,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                3 /
                                                testScreenHeight),
                                        child: Text(
                                          "$programDateWeeks $dashboardListViewItemWeeksText",
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(16),
                                            color:
                                                dashboardListViewItemWeeksTextBlackColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              5 /
                                              testScreenHeight,
                                        ),
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
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
