import 'dart:developer' as dev;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uuid/uuid.dart';
import '../../dashboard/dashboard_interactor.dart';
import '../../home_screen/interactor/home_screen_interactor.dart';
import '../../messaging_screen/entity/user.dart';
import '../../utils/constants.dart';
import '../interactor/interactor_chat.dart';
import '../widgets/message_tile.dart';

class ChatScreen extends StatefulWidget {
  final UserData messageUser;

  const ChatScreen(this.messageUser);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  final timeStamp = DateTime.now();
  late File file;
  bool? isLoading;
  String imageMessageId = const Uuid().v4();
  String fileMessageId = const Uuid().v1();
  var myCurrentUser = FirebaseAuth.instance.currentUser;
  bool isFirstTime = true;
  Color kGreenColor = const Color(0xff58DC84);

  bool emojiShowing = false;

  //
  // _onEmojiSelected(Emoji emoji) {
  //   print('_onEmojiSelected: ${emoji.emoji}');
  // }
  @override
  void initState() {
    InteractorChat.setUnseen0(widget.messageUser.uid);
  }

  _onBackspacePressed() {}

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  int appHeight = 896;
  int appWidth = 414;
  final CollectionReference refUsers =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference refChats =
      FirebaseFirestore.instance.collection('chatrooms');

  clearCount() async {
    await interactorChat.clearCount(
        widget.messageUser.uid!, myCurrentUser?.uid);
  }

  @override
  void didChangeDependencies() {
    if (isFirstTime) {
      myCurrentUser = FirebaseAuth.instance.currentUser;
      interactorChat.counterHandle(widget.messageUser.uid!, myCurrentUser!.uid);
      clearCount();
      isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  // onWillPop: () {
  //    Navigator.pop(context, true);
  // } as Future<bool> Function()?,
  Future<String> getUserAvatarUrl(String? uid) async {
    return await HomeScreenInteractor.getPpUrlOfUser(uid!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.height * 91.5 / appHeight,
        backgroundColor: const Color(0xFF000000),
        leading: IconButton(
          icon: SvgPicture.asset(
            "${imagePath}back_button.svg",
          ),
          iconSize: 24,
          onPressed: () {
            Navigator.pop(context);
            dev.log("[Messaging] pressed on back button");
          },
        ),
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(
              right: 16,
              left: 60,
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / (appWidth / 64),
                    height:
                        MediaQuery.of(context).size.height / (appHeight / 64),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          20,
                        ),
                      ),
                      child: FutureBuilder<String>(
                        future: getUserAvatarUrl(widget.messageUser.uid!),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                                margin: const EdgeInsets.all(10),
                                child: const CircularProgressIndicator());
                            // return const Text(
                            //   'No avatar picture found',
                            //   style: TextStyle(
                            //     color: messagingTitleWhiteColor,
                            //   ),
                            // );
                          }
                          if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(
                                color: messagingTitleWhiteColor,
                              ),
                            );
                          }
                          return Image.network(
                            snapshot.data!, //TODO: add pp
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.messageUser.username!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: ScreenUtil().setSp(20),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 1,
                          ),
                          Text(
                            "Online",
                            style: TextStyle(
                              color: Color(0xFFFFE241),
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF000000),
      body: Column(
        children: [
          Container(width: double.infinity, height: .25, color: Colors.black),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: refChats
                  .doc(interactorChat.returnNameOfChat(
                      widget.messageUser.uid!, myCurrentUser!.uid))
                  .collection('chatmessages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  InteractorChat.setUnseen0(widget.messageUser.uid);

                  return ListView.builder(
                    reverse: true,
                    itemCount: (snapshot.data!).docs.length,
                    itemBuilder: (context, index) {
                      String? sender = snapshot.data?.docs[index]['sentby'];
                      UserData? messageSender;
                      if (sender == myCurrentUser!.uid) {
                        messageSender = UserData(
                          email: myCurrentUser?.email,
                          uid: myCurrentUser!.uid,
                        );
                      } else {
                        messageSender = widget.messageUser;
                      }
                      return MessageTile(
                        message: snapshot.data?.docs[index]['message'],
                        messageSender: messageSender,
                        isPhoto: snapshot.data?.docs[index]['isphoto'],
                        timeStamp:
                            snapshot.data?.docs[index]['timestamp'].toString(),
                      );
                    },
                  );
                }
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / (appHeight / 75),
            width: MediaQuery.of(context).size.width / (appWidth / 359),
            child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        20,
                      ),
                    ),
                    color: Color(0xFFFFFFFF)),
                padding:
                    const EdgeInsets.symmetric(vertical: 2.5, horizontal: 9.75),
                child: Row(
                  children: [
                    SizedBox(
                      width:
                          MediaQuery.of(context).size.width / (appWidth / 31.1),
                    ),
                    SizedBox(
                      width:
                          MediaQuery.of(context).size.width / (appWidth / 170),
                      child: TextField(
                        onTap: () {
                          setState(() {
                            emojiShowing = false;
                          });
                        },
                        textInputAction: TextInputAction.go,
                        onSubmitted: (value) {
                          if (!messageController.text.isEmpty) {
                            interactorChat.submitMessage(
                                widget.messageUser.uid!,
                                messageController.text,
                                myCurrentUser!.uid);

                            messageController.clear();
                          } else {}
                        },
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 1,
                        autocorrect: true,
                        enableSuggestions: true,
                        controller: messageController,
                        decoration: const InputDecoration(
                            hintText: "Type your message...",
                            hintStyle: TextStyle(color: Color(0xFF848484)),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width:
                          MediaQuery.of(context).size.width / (appWidth / 10),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              //open file picker and upload file to the storage
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();

                              if (result != null) {
                                PlatformFile file = result.files.first;
                                File filetoUpload = File(file.path!);
                                String fileName =
                                    await InteractorChat.uploadFile(
                                        filetoUpload, fileMessageId);

                                await interactorChat.sendMessage(
                                    widget.messageUser.uid!,
                                    myCurrentUser!.uid,
                                    fileName,
                                    myCurrentUser!.uid,
                                    "file",
                                    interactorChat.getCounter()!);
                              } else {
                                // User canceled the picker
                              }
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height /
                                  (appHeight / 23),
                              width: MediaQuery.of(context).size.width /
                                  (appWidth / 23),
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(
                                  30,
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: blueColor,
                                size: 30,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width /
                                (appWidth / 23.7),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                emojiShowing = !emojiShowing;
                              });
                              //FocusScope.of(context).unfocus();
                              FocusManager.instance.primaryFocus?.unfocus();

                              dev.log("Clicked emoji button");
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height /
                                  (appHeight / 23),
                              width: MediaQuery.of(context).size.width /
                                  (appWidth / 23),
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(
                                Icons.emoji_emotions_sharp,
                                color: blueColor,
                                size: 30,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width /
                                (appWidth / 23.7),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: GestureDetector(
                              onTap: () {
                                interactorChat.selectImage(context,
                                    widget.messageUser.uid, myCurrentUser!.uid);

                                dev.log("Clicked send button");
                                dev.log("Trying the sending this message:");
                              },
                              child: SvgPicture.asset(
                                "${imagePath}camera.svg",
                                width: MediaQuery.of(context).size.width /
                                    (appWidth / 30),
                                height: MediaQuery.of(context).size.height /
                                    (appHeight / 30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          Offstage(
            offstage: !emojiShowing,
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                height: 250,
                child: EmojiPicker(
                    onEmojiSelected: (Category category, Emoji emoji) {
                      setState(() {
                        messageController.text =
                            messageController.text + emoji.emoji;
                      });
                    },
                    onBackspacePressed: _onBackspacePressed,
                    config: Config(
                        columns: 7,
                        // Issue: https://github.com/flutter/flutter/issues/28894
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.RECENT,
                        bgColor: const Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        progressIndicatorColor: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        showRecentsTab: true,
                        recentsLimit: 28,
                        replaceEmojiOnLimitExceed: false,
                        noRecents: Text(
                          'No Recents',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(20),
                              color: Colors.black26),
                          textAlign: TextAlign.center,
                        ),
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
