import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_elite_app/chat_screen/interactor/interactor_chat.dart';
import 'package:sport_elite_app/chat_screen/view/chat_screen_view.dart';
import '../chat_screen/entity/message.dart';
import 'entity/user.dart';

class UserTile extends StatefulWidget {
  final UserData messageUser;

  UserTile(this.messageUser);

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<UserTile> {
  Message? myMessage;
  User? currentUser = FirebaseAuth.instance.currentUser;
  var messagesProvider;
  InteractorChat interactorChat = InteractorChat();

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  int? count;

  getCountofUnseenMsgs() async {
    int? testCount = await interactorChat.getCount(
        currentUser!.uid, widget.messageUser.uid!);
    setStateIfMounted(() {
      count = testCount;
    });
  }

  getLastMessage() async {
    Message? myTestMessage = await interactorChat.getLastMessage(
        widget.messageUser.uid!, currentUser!.uid);
    setStateIfMounted(() {
      myMessage = myTestMessage;
    });
  }

  @override
  void didChangeDependencies() {
    getLastMessage();
    getCountofUnseenMsgs();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    getCountofUnseenMsgs();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatScreen(
            widget.messageUser,
          );
        })).then(
          (value) {
            if (value == true) {
              getCountofUnseenMsgs();
              getLastMessage();
            } else {
              getCountofUnseenMsgs();
              getLastMessage();
            }
          },
        );
      },
      child: Container(
        color: count == 0 || count == null ? Colors.white : Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(top: 0.6, bottom: 0.6),
          child: SizedBox(
            height: 12.0,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.5, right: 11.25),
              child: Center(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 2.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.messageUser.email!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                        SizedBox(
                          width: 40.0,
                          child: Text(
                            myMessage?.message == null
                                ? ''
                                : myMessage?.isPhoto == true
                                    ? 'Sent photo'
                                    : myMessage!.message,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    count == 0 || count == null
                        ? const Text('')
                        : Container(
                            height: 27,
                            width: 27,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(27)),
                            child: Center(
                              child: Text(
                                '$count',
                              ),
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
