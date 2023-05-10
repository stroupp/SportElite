import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport_elite_app/chat_screen/interactor/interactor_chat.dart';
import 'package:sport_elite_app/messaging_screen/user_tile.dart';
import '../chat_screen/providers/user_provider.dart';
import 'entity/user.dart';

class ChatRooms extends StatefulWidget {
  final List<UserData> users;

  const ChatRooms({super.key, required this.users});

  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  Color kGreenColor = const Color(0xff58DC84);
  final CollectionReference refUsers =
      FirebaseFirestore.instance.collection('users');
  InteractorChat interactorChat = InteractorChat();
  Stream<QuerySnapshot>? mySnapshot;
  int? chatCount = 0;
  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  getChatsCount() async {
    QuerySnapshot snapshot = await refUsers.get();
    void setStateIfMounted(f) {
      if (mounted) setState(f);
    }

    setStateIfMounted(() {
      chatCount = snapshot.docs.length - 1;
    });
  }

  @override
  void initState() {
    getChatsCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            SizedBox(
              height: 13.5,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.5, right: 8.25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.8, horizontal: 2.25),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Text(
                            '$chatCount',
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 3.25, right: 1.5, top: 0.5),
                          child: Text(
                            'Chats',
                          ),
                        ),
                        Icon(
                          Icons.more_horiz,
                          color: kGreenColor,
                          size: 23.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: (1 / 6.7),
              width: double.infinity,
              color: Colors.grey[200],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                onChanged: (val) async {
                  Stream<QuerySnapshot> snapshot = refUsers
                      .where('username',
                          isGreaterThanOrEqualTo: searchController.text)
                      .snapshots();
                  setState(() {
                    mySnapshot = snapshot;
                  });
                },
                controller: searchController,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: kGreenColor,
                      size: 22.0,
                    ),
                    hintText: 'Search',

                    // contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    // isDense: true,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: mySnapshot == null ? refUsers.snapshots() : mySnapshot,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    chatCount = (snapshot.data!).docs.length;
                    return ListView.builder(
                        //reverse: true,
                        itemCount: (snapshot.data!).docs.length,
                        itemBuilder: (context, index) {
                          UserData friendUser = UserData.fromDocument(
                              (snapshot.data!).docs[index]);

                          String? myUserId =
                              Provider.of<UserProvider>(context, listen: false)
                                  .myUser
                                  ?.uid;
                          if (friendUser.uid != myUserId) {
                            return UserTile(friendUser);
                          } else {
                            return Container();
                          }
                        });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
