import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sport_elite_app/messaging_screen/empty_request_view.dart';
import 'package:sport_elite_app/messaging_screen/request_messages_view.dart';
import '../utils/constants.dart';
import 'all_users_list_view.dart';
import 'entity/user.dart';
import 'interactor/firebase_messaging_service.dart';

class MessagingView extends StatefulWidget {
  const MessagingView({Key? key}) : super(key: key);

  @override
  State<MessagingView> createState() => _MessagingViewState();
}

class _MessagingViewState extends State<MessagingView> {
  final int _requestMessages = 4;
  bool? _isPressedAllButton = true;

  //TODO: add these to the localization
  final String messaging_emptyRequestBox_text =
      "Message requests are received from other users who are not in your contact list. ";
  final String messaging_goToMessageControls_text =
      "Go to \"Message Controls\" to decide who can message you.";
  final String messaging_noMessageRequests_text = "No message requests";
  final String messaging_noRequestMessages_text =
      "There are no message requests here.";
  final String messaging_RequestBox_openChat_text =
      "Open a chat to see who is trying to reach out.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight:
            MediaQuery.of(context).size.height * 66 / testScreenHeight,
        backgroundColor: messagingBackgroundBlackColor,
        leading: IconButton(
          icon: SvgPicture.asset(
            "${imagePath}back_button.svg",
          ),
          iconSize: 24,
          onPressed: () {
            dev.log("[Messaging] pressed on back button");
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Inbox',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(
              30,
            ),
            color: yellowColor,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              "${imagePath}messaging_search.svg",
              height:
                  MediaQuery.of(context).size.height * 23.83 / testScreenHeight,
              width:
                  MediaQuery.of(context).size.width * 19.16 / testScreenWidth,
            ),
            onPressed: () {
              dev.log("[Messaging] pressed on search button");
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              "${imagePath}messaging_send_button.svg",
              fit: BoxFit.cover,
              height:
                  MediaQuery.of(context).size.height * 21.67 / testScreenHeight,
              width:
                  MediaQuery.of(context).size.width * 24.36 / testScreenWidth,
            ),
            onPressed: () {
              dev.log("[Messaging] pressed on menu button");
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 1.0,
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: yellowColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            17.0,
                          ),
                        ),
                      ),
                      minimumSize: Size(
                        MediaQuery.of(context).size.width *
                            133 /
                            testScreenWidth,
                        MediaQuery.of(context).size.height *
                            41.84 /
                            testScreenHeight,
                      ),
                    ),
                    child: Text(
                      "Request",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(
                          20,
                        ),
                        fontWeight: FontWeight.w400,
                        color: messagingBackgroundBlackColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: yellowColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            17.0,
                          ),
                        ),
                      ),
                      minimumSize: Size(
                        MediaQuery.of(context).size.width *
                            133 /
                            testScreenWidth,
                        MediaQuery.of(context).size.height *
                            41.84 /
                            testScreenHeight,
                      ),
                    ),
                    child: Text(
                      "All",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(
                          20,
                        ),
                        fontWeight: FontWeight.w400,
                        color: messagingBackgroundBlackColor,
                      ),
                    ),
                  ),
                ],
              ),
              if (_isPressedAllButton! == false)
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          16.5 /
                          testScreenHeight,
                    ),
                    Text(
                      messaging_RequestBox_openChat_text,
                      style: TextStyle(
                        color: messagingRequestBoxGreyColor,
                        fontSize: ScreenUtil().setSp(
                          12,
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    50.5 /
                    testScreenHeight,
              ),
              StreamBuilder<List<UserData>>(
                stream: FirebaseMessagingService.getUsers(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      if (snapshot.hasError) {
                      } else {
                        List<UserData> users = snapshot.data!;
                        if (users == null) {}

                        return Expanded(
                          child: _isPressedAllButton! == false
                              ? _requestMessages == 0
                                  ? EmptyRequestView()
                                  : const RequestView()
                              : const AllUsersListView(),
                        );
                      }
                  }
                  return const Center(
                    child: Text(
                      "No users list available",
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
