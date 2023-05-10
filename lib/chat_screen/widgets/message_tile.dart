import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sport_elite_app/chat_screen/widgets/requestWidget.dart';
import '../../messaging_screen/entity/user.dart';
import '../interactor/interactor_chat.dart';

const int appHeight = 896;
const int appWidth = 414;

class MessageTile extends StatefulWidget {
  final UserData messageSender;

  final String? message;
  final String? isPhoto;
  final timeStamp;

  MessageTile(
      {this.message,
      required this.messageSender,
      this.isPhoto,
      this.timeStamp});

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  UserData? myCurrentUser = UserData(
      email: FirebaseAuth.instance.currentUser?.email,
      uid: FirebaseAuth.instance.currentUser!.uid);
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isFirstTime) {
      isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  bool showData = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isPhoto == "photo") {
      return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ImageScreen(widget.message);
          }));
        },
        child: Container(
          margin: widget.messageSender.uid == myCurrentUser!.uid
              ? EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / (appWidth / 45),
                  bottom: 11.0)
              : EdgeInsets.only(
                  right: MediaQuery.of(context).size.width / (appWidth / 45),
                  bottom: 11.0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
            width: MediaQuery.of(context).size.width / (appWidth / 286),
            height: MediaQuery.of(context).size.height / (appHeight / 209),
            child: ClipRRect(
                borderRadius: widget.messageSender.uid == myCurrentUser!.uid
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30))
                    : const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                child: CachedNetworkImage(
                  imageUrl: widget.message!,
                  placeholder: (context, string) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  alignment: widget.messageSender.uid != myCurrentUser!.uid
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  fit: BoxFit.fill,
                )),
          ),
        ),
      );
    } else if (widget.isPhoto == "directMessage") {
      return GestureDetector(
        onTap: () {
          setStateIfMounted(() {
            if (showData == false) {
              showData = true;
            } else {
              showData = false;
            }
          });
        },
        child: Container(
            child: widget.messageSender.uid == myCurrentUser!.uid
                ? Container(
                    padding: EdgeInsets.only(
                      right:
                          MediaQuery.of(context).size.width / (appWidth / 45),
                      bottom: 11,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(27),
                                bottomLeft: Radius.circular(27),
                                bottomRight: Radius.circular(27),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              widget.message!,
                              style: TextStyle(
                                color: const Color(0xFF131313),
                                fontSize: ScreenUtil().setSp(
                                  15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: EdgeInsets.only(
                        left:
                            MediaQuery.of(context).size.width / (appWidth / 45),
                        bottom: 11),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.only(
                            bottom: 5,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFE241),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(
                                27,
                              ),
                              topLeft: Radius.circular(
                                8,
                              ),
                              bottomLeft: Radius.circular(
                                27,
                              ),
                              bottomRight: Radius.circular(
                                27,
                              ),
                            ),
                          ),
                          child: Text(
                            widget.message!,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(
                                15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
      );
    } else if (widget.isPhoto == "request") {
      return Padding(
          padding: widget.messageSender.uid == myCurrentUser!.uid
              ? EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / (appWidth / 71),
                  right: MediaQuery.of(context).size.width / (appWidth / 45),
                  bottom: 11.0)
              : EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / (appWidth / 45),
                  right: MediaQuery.of(context).size.width / (appWidth / 75),
                  bottom: 11.0),
          child: requestComing(
            offerCompilation: widget.message!,
            messageSenderID: widget.messageSender.uid,
            currentID: myCurrentUser!.uid,
          ));
    } else {

      var messageArr = widget.message!.split(".");
      var extension = messageArr[messageArr.length-1];
      var fileName = messageArr[0];
      var extensionIcon = Icons.insert_drive_file;
      if(extension == "jpg") {
        extensionIcon = Icons.image;

      } else if(extension == "pdf") {
        extensionIcon = Icons.picture_as_pdf;
      }
      else{
        extensionIcon = Icons.insert_drive_file;
      }


      return Container(

        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),

        margin: widget.messageSender.uid == myCurrentUser!.uid
            ? EdgeInsets.only(
                left: MediaQuery.of(context).size.width / (appWidth / 190),
                bottom: 11.0)
            : EdgeInsets.only(
                right: MediaQuery.of(context).size.width / (appWidth / 190),
                bottom: 11.0),
        child: ClipRRect(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Stack(
                
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
          ,color: const Color(0xffEEC61F),),
                    width: 130,
                    height: 80,
                  ),
                  Column(
                    children: <Widget>[
                       Icon(
                        extensionIcon,
                        color: Colors.blue,
                         size: 33,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / (appWidth / 90),
                        height: MediaQuery.of(context).size.height / (appHeight / 20),
                        child: Text(
                          //Change it to the file name
                          fileName,

                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(
                                13,
                              ),
                              color: Colors.blue,
                          overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                  decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10))
                    ,color: Colors.blue),

                  height: MediaQuery.of(context).size.height / (appHeight / 45),
                  width: MediaQuery.of(context).size.width / (appWidth / 130),
                  child: IconButton(
                      icon: const Icon(
                        Icons.file_download,
                        color: Colors.white,

                      ),
                      onPressed: () async {
                        // Either the permission was already granted before or the user just granted it.
                        if (await Permission.storage.request().isGranted) {
                          InteractorChat.downloadFile(widget.message!);
                        }

                        // code of read or write file in external storage (SD card)

                        //download the file
                      })),
            ],
          ),
        ),
      );
    }
  }
}

class ImageScreen extends StatelessWidget {
  final String? photoUrl;

  ImageScreen(this.photoUrl);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CachedNetworkImage(
        imageUrl: photoUrl!,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        maxHeightDiskCache: 300,
        maxWidthDiskCache: 300,
      ),
    );
  }
}
