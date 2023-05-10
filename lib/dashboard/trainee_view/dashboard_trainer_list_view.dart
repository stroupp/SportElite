import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sport_elite_app/dashboard/dashboard_empty_view.dart';
import 'package:sport_elite_app/dashboard/dashboard_presenter.dart';
import 'package:sport_elite_app/messaging_screen/entity/user.dart';
import 'package:sport_elite_app/utils/constants.dart';
import '../../chat_screen/view/chat_screen_view.dart';
import '../../utils/constants.dart';
import '../../utils/localization_en.dart';
import 'dart:developer' as dev;

class DashboardTrainerListView extends StatefulWidget {
  const DashboardTrainerListView({Key? key}) : super(key: key);

  @override
  State<DashboardTrainerListView> createState() =>
      _DashboardTraineeListViewState();
}

class _DashboardTraineeListViewState extends State<DashboardTrainerListView> {
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
        stream: dashboardPresenter.onGetRegisteredTrainers(),
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
                'No Registered Trainers found',
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
              dev.log("[TrainerListView]snapshot: ${snapshot.data!}");
              var registeredTrainerId = snapshot.data!.docs[index].id;
              dev.log("[TrainerListView]TrainerId: $registeredTrainerId");
              return FutureBuilder(
                future: dashboardPresenter.onGetUserInfo(registeredTrainerId),
                builder: (BuildContext context, AsyncSnapshot trainerSnapshot) {
                  if (trainerSnapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${trainerSnapshot.error}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  } else if (trainerSnapshot.data == null) {
                    return const Center(
                      child: Text(
                        'No trainer found',
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  } else if (trainerSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Get all trainee data
                  var trainerData = trainerSnapshot.data;

                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      right: 30.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        var userData = UserData(
                          uid: trainerData["uid"],
                          email: trainerData["email"],
                          username: trainerData["username"],
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
                                        trainerSnapshot.data["uid"])
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
                                          "${trainerSnapshot.data["username"]}",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(
                                              15,
                                            ),
                                            color: Colors.black,
                                          ),
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
                            ],
                          ),
                        )
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
