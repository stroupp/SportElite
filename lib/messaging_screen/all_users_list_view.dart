import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sport_elite_app/chat_screen/interactor/interactor_chat.dart';
import 'package:sport_elite_app/home_screen/interactor/home_screen_interactor.dart';
import '../chat_screen/view/chat_screen_view.dart';
import '../utils/constants.dart';
import 'entity/user.dart';
import 'interactor/firebase_messaging_service.dart';

class AllUsersListView extends StatefulWidget {
  const AllUsersListView({
    Key? key,
  }) : super(key: key);

  @override
  State<AllUsersListView> createState() => _AllUsersListViewState();
}

class _AllUsersListViewState extends State<AllUsersListView> {
  //TODO: Get Length of  the firebase messages list
  final int? _incomingMessages = 100;
  final FirebaseMessagingService _firebaseMessagingService =
      FirebaseMessagingService();
  final CollectionReference refUsers =
      FirebaseFirestore.instance.collection('users');

  InteractorChat interactorChat = InteractorChat();
  Stream<QuerySnapshot>? mySnapshot;

  Future<String> getUserAvatarUrl(String? uid) async {
    return await HomeScreenInteractor.getPpUrlOfUser(uid!);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: mySnapshot == null ? refUsers.snapshots() : mySnapshot,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).padding.left * 20 / testScreenWidth,
            ),
            itemCount: (snapshot.data!).docs.length,
            itemBuilder: (BuildContext context, int index) {
              final user = UserData.fromDocument((snapshot.data!).docs[index]);
              final uid = user.uid;
              final username = user.username;

              return GestureDetector(
                onTap: () {
                  final user =
                      UserData.fromDocument((snapshot.data!).docs[index]);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(user),
                    ),
                  );
                  dev.log("[Messaging] pressed on item $index");
                },
                child: Container(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.height *
                        25 /
                        testScreenHeight,
                    left: MediaQuery.of(context).size.height *
                        26 /
                        testScreenHeight,
                    bottom: MediaQuery.of(context).size.height *
                        28 /
                        testScreenHeight,
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 10,
                        child: Row(
                          children: [
                            Flexible(
                              flex: 4,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    82 /
                                    testScreenWidth,
                                height: MediaQuery.of(context).size.height *
                                    82 /
                                    testScreenHeight,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                      20,
                                    ),
                                  ),
                                  child: user.imageURL != null
                                      ? Image.network(user.imageURL!)
                                      : const Center(
                                          child:
                                              Text("This user has no image")),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    25 /
                                    testScreenWidth,
                              ),
                            ),
                            Flexible(
                              flex: 9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.username!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: messagingMessageTitleWhiteColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        4 /
                                        testScreenWidth,
                                  ),
                                  FutureBuilder(
                                      future: InteractorChat
                                          .returnLastMessageOfChat(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid!,
                                              user.uid),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            "${snapshot.data}",
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: yellowColor,
                                            ),
                                          );
                                        } else {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Center(
                                                child: Text(
                                                  "",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: yellowColor,
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                            ],
                                          );
                                        }
                                      })
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    70 /
                                    testScreenWidth,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FutureBuilder(
                                future: InteractorChat.returnLastMessageTime(
                                    FirebaseAuth.instance.currentUser!.uid!,
                                    user.uid!),
                                builder: (cont, sn) {
                                  if (sn.hasData) {
                                    return Text(
                                      "${sn.data}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: messagingDateGreyColor,
                                      ),
                                    );
                                  } else {
                                    return const Text(
                                      "",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: messagingDateGreyColor,
                                      ),
                                    );
                                  }
                                }),
                            SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  17.3 /
                                  testScreenHeight,
                            ),
                            if (_incomingMessages == 0)
                              SvgPicture.asset(
                                "${imagePath}opened_messages.svg",
                              )
                            else
                              FutureBuilder(
                                  future:
                                      InteractorChat.returnUnseenMessageCount(
                                          user.uid!),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      int unseenCount = snapshot.data as int;
                                      if (unseenCount == 0) {
                                        return Container();
                                      } else {
                                        return CircleAvatar(
                                            backgroundColor: yellowColor,
                                            radius: 13,
                                            child:
                                                Text(snapshot.data.toString()));
                                      }
                                    } else {
                                      return Container();
                                    }
                                  }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
