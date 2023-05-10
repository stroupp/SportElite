import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../entity/message.dart';

class InteractorChat {
  int? counter;
  String imageMessageId = const Uuid().v4();
  String fileMessageId = const Uuid().v1();

  var url;

  bool? isLoading;
  late File file;
  final CollectionReference refUsers =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference refChats =
      FirebaseFirestore.instance.collection('chatrooms');

  TextEditingController messageController = TextEditingController();

  int? getCounter() {
    return counter;
  }

  static Future<String> uploadImageToStorge(
      File? imageFile, String imageId) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('image_$imageId');
    TaskSnapshot taskSnapshot = await ref.putFile(imageFile!);
    return await taskSnapshot.ref.getDownloadURL();
  }

  //
  // Future<List<String>> allUsers(am.UserData currentUser) async {
  //   List<String> listOfUsers = [];
  //   try {
  //     QuerySnapshot querySnapshot =
  //     await refUsers.where('uid', isNotEqualTo: currentUser.uid).get();
  //     for (int i = 0; i < querySnapshot.docs.length; i++) {
  //       listOfUsers.add(querySnapshot.docs[i]['username']);
  //     }
  //     print(listOfUsers);
  //     return listOfUsers;
  //   } catch (e) {
  //     print(e);
  //     throw (e);
  //   }
  // }

  sendMessage(String userMessageName, String myCurrentUserName, String message,
      String? myCurrentUserUid, String? isPhoto, int? counter) async {
    String fullname = returnNameOfChat(userMessageName, myCurrentUserName);
    await refChats.doc(fullname).collection('chatmessages').add({
      'message': message,
      'timestamp': new DateTime.now(),
      'sentby': myCurrentUserUid,
      'isphoto': isPhoto,
    });
    //send message to counter unseen messages
    await increaseCount(counter!, userMessageName, myCurrentUserName);

    //send message to last messages collection
    await refChats
        .doc(fullname)
        .collection('unseenmessages')
        .doc('lastmessage')
        .set({
      'message': message,
      'timestamp': new DateTime.now(),
      'sentby': myCurrentUserUid,
      'isphoto': isPhoto,
    });
  }

  returnNameOfChat(String name1, String? name2) {
    int numberr = [name1.length, name2!.length].reduce(min);
    for (int i = 0; i < numberr; i++) {
      if (name1[i].codeUnitAt(0) < name2[i].codeUnitAt(0)) {
        return '$name1 _ $name2'.trim();
      } else if (name1[i].codeUnitAt(0) > name2[i].codeUnitAt(0)) {
        return '$name2 _ $name1'.trim();
      }
    }
    return '$name1 _ $name2'.trim();
  }

  deleteRequestMessages(
      String messageUserID, String? currentID, String message) async {
    String chatName =
        InteractorChat().returnNameOfChat(messageUserID, currentID);
    try {
      CollectionReference col_ref = await new InteractorChat()
          .refChats
          .doc(chatName)
          .collection('chatmessages');

      QuerySnapshot colSnap = await col_ref.get();
      colSnap.docs.forEach((element) async {
        if (element["isphoto"] == "request") {
          await col_ref.doc(element.id).delete();
        }
      });
      sendMessage(messageUserID, currentID!, message, currentID,
          "directMessage", counter);
    } catch (e) {}
  }

  static Future<String> returnLastMessageOfChat(
      String uid1, String uid2) async {
    String chatName = new InteractorChat().returnNameOfChat(uid1, uid2);
    DocumentSnapshot documentSnapshot = await new InteractorChat()
        .refChats
        .doc(chatName)
        .collection('unseenmessages')
        .doc('lastmessage')
        .get();
    String lastM = documentSnapshot["message"];
    return lastM;
  }

  static Future<String> returnLastMessageTime(String uid1, String uid2) async {
    String chatName = new InteractorChat().returnNameOfChat(uid1, uid2);
    DocumentSnapshot documentSnapshot = await new InteractorChat()
        .refChats
        .doc(chatName)
        .collection('unseenmessages')
        .doc('lastmessage')
        .get();
    Timestamp lastMTime = documentSnapshot["timestamp"];
    int h = lastMTime.toDate().hour;
    int m = lastMTime.toDate().minute;

    String minute = m.toString();
    String hour = h.toString();
    if (m < 10) {
      minute = "0$m";
    }
    if (h < 10) {
      hour = "0$h";
    }
    return "$hour : $minute";
  }

  static Future<int> returnUnseenMessageCount(String uidOfOtherPerson) async {
    try {
      String chatName = new InteractorChat().returnNameOfChat(
          FirebaseAuth.instance.currentUser!.uid!, uidOfOtherPerson);
      DocumentSnapshot documentSnapshot = await new InteractorChat()
          .refChats
          .doc(chatName)
          .collection('unseenmessages')
          .doc(FirebaseAuth.instance.currentUser!.uid!)
          .collection("unseen_chat_screen")
          .doc("unseen_chat_screen")
          .get();
      int messageCount = documentSnapshot["count_for_lw"];
      return messageCount;
    } catch (e) {
      dev.log(e.toString());
      return 0;
    }
  }

  static Future setUnseen0(String uidOfOtherPerson) async {
    try {
      String chatName = new InteractorChat().returnNameOfChat(
          FirebaseAuth.instance.currentUser!.uid!, uidOfOtherPerson);
      await new InteractorChat()
          .refChats
          .doc(chatName)
          .collection('unseenmessages')
          .doc(FirebaseAuth.instance.currentUser!.uid!)
          .collection("unseen_chat_screen")
          .doc("unseen_chat_screen")
          .set({
        'count_for_lw': 0,
      });
    } catch (e) {
      dev.log(e.toString());
    }
  }

  static Future incrementUnseenMessageCount(String uidOfOtherPerson) async {
    try {
      String chatName = new InteractorChat().returnNameOfChat(
          FirebaseAuth.instance.currentUser!.uid!, uidOfOtherPerson);
      int oldC;
      try {
        String chatName = await new InteractorChat().returnNameOfChat(
            FirebaseAuth.instance.currentUser!.uid!, uidOfOtherPerson);
        DocumentSnapshot documentSnapshot = await new InteractorChat()
            .refChats
            .doc(chatName)
            .collection('unseenmessages')
            .doc(uidOfOtherPerson)
            .collection("unseen_chat_screen")
            .doc("unseen_chat_screen")
            .get();
        oldC = documentSnapshot['count_for_lw'];
      } catch (e) {
        dev.log(e.toString());
        oldC = 0;
      }
      oldC++;
      await new InteractorChat()
          .refChats
          .doc(chatName)
          .collection('unseenmessages')
          .doc(uidOfOtherPerson)
          .collection("unseen_chat_screen")
          .doc("unseen_chat_screen")
          .set({
        'count_for_lw': oldC,
      });
    } catch (e) {
      dev.log(e.toString());
    }
  }

  listOfLastMessages(List<String> chatNames) async {
    Map<String, String> mapOfChatNamesAndLastMessages = {};
    for (int i = 0; i < chatNames.length; i++) {
      DocumentSnapshot documentSnapshot = await refChats
          .doc(chatNames[i])
          .collection('unseenmessages')
          .doc('lastmessage')
          .get();
      String lastMessage = documentSnapshot['message'];
      mapOfChatNamesAndLastMessages.putIfAbsent(
          chatNames[i], () => lastMessage);
    }
  }

  increaseCount(
      int count, String userMessageName, String myCurrentUserName) async {
    String fullname = returnNameOfChat(userMessageName, myCurrentUserName);
    await refChats
        .doc(fullname)
        .collection('unseenmessages')
        .doc(userMessageName)
        .set({'count': count + 1});
  }

  Future<int> getCount(String userMessageName, String myCurrentUserName) async {
    try {
      int myCount;
      String fullname = returnNameOfChat(userMessageName, myCurrentUserName);
      DocumentSnapshot doc = await refChats
          .doc(fullname)
          .collection('unseenmessages')
          .doc(userMessageName)
          .get();
      if (doc.exists) {
        myCount = doc['count'];
      } else {
        myCount = 0;
      }
      return myCount;
    } catch (e) {
      return -1;
    }
  }

  Future<String> getLastMessageText(
      String messageUserUid, String currentUserUid) async {
    Message? myTestMessage =
        (await getLastMessage(messageUserUid, currentUserUid));
    return myTestMessage!.message;
  }

  Future<Message?> getLastMessage(
      String userMessageName, String myCurrentUserName) async {
    try {
      String fullname = returnNameOfChat(userMessageName, myCurrentUserName);
      DocumentSnapshot doc = await refChats
          .doc(fullname)
          .collection('unseenmessages')
          .doc('lastmessage')
          .get();
      if (doc.exists) {
        Message myMessage = Message.fromDocument(doc);
        return myMessage;
      } else {
        return null;
      }
    } catch (e) {}
  }

  clearCount(String userMessageName, String? myCurrentUserName) async {
    try {
      String fullname = returnNameOfChat(userMessageName, myCurrentUserName!);
      await refChats
          .doc(fullname)
          .collection('unseenmessages')
          .doc(myCurrentUserName)
          .set({'count': 0});
    } catch (e) {}
  }

  static Future<String> uploadFile(File file, String fileID) async {
    var bytes = await file.readAsBytes();

    String path = file.path.toString();
    var ar = path.split("/");
    var fileName = ar[ar.length-1];
    var type = path.split(".");
    var extension = type[type.length - 1];

    // Upload file
    try {
      await FirebaseStorage.instance.ref('document_$fileID').putData(bytes);
      return "${fileName}_$fileID.$extension";
    } catch (e) {
      return "failed";
    }
  }

  static downloadFile(String fileName) async {
    final storageRef = FirebaseStorage.instance.ref();
    var ar = fileName.split(".");
    String trimmedFileName = ar[0];

    final islandRef = storageRef.child(trimmedFileName);

    // final islandRef = storageRef.child("images/island.jpg");

    final appDocDir = await getApplicationDocumentsDirectory();

    String filePath = "/storage/emulated/0/Download/$fileName";
    final file = File(filePath);
    final downloadTask = islandRef.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          break;
        case TaskState.paused:
          break;
        case TaskState.success:
          break;
        case TaskState.canceled:
          break;
        case TaskState.error:
          break;
      }
    });
  }

  submitMessage(
      String messageUserUid, String message, String currentUserUid) async {
    await sendMessage(messageUserUid, currentUserUid, message, currentUserUid,
        "directMessage", counter!);

    await counterHandle(messageUserUid, currentUserUid);
    await incrementUnseenMessageCount(messageUserUid);
  }

  counterHandle(String messageUserUid, String currentUserUid) async {
    int? counttest = await getCount(messageUserUid, currentUserUid);

    counter = counttest;
  }

  submitImage(String messageUserUid, String currentUserUid) async {
    isLoading = true;

    String photoUrl = await uploadImageToStorge(file, imageMessageId);
    await sendMessage(messageUserUid, currentUserUid, photoUrl, currentUserUid,
        "photo", counter!);
    // file=null;
    isLoading = false;
  }

  imageFromGallery(
      context, String messageUserUid, String currentUserUid) async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 85);

    file = File(pickedFile!.path);

    submitImage(messageUserUid, currentUserUid);
  }

  imageFromCamera(context, String messageUserUid, String currentUserUid) async {
    Navigator.pop(context);
    final pickedFile =
        await ImagePicker(). /*getImage*/ pickImage(source: ImageSource.camera);

    file = File(pickedFile!.path);

    submitImage(messageUserUid, currentUserUid);
  }

  selectImage(parentContext, String messageUserUid, String currentUserUid) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Upload a photo'),
            children: [
              SimpleDialogOption(
                child: const Text(
                  'Choose an image From Gallery',
                ),
                onPressed: () {
                  imageFromGallery(
                      parentContext, messageUserUid, currentUserUid);
                },
              ),
              SimpleDialogOption(
                child: const Text(
                  'Open camera',
                ),
                onPressed: () {
                  imageFromCamera(
                      parentContext, messageUserUid, currentUserUid);
                },
              ),
              SimpleDialogOption(
                child: const Text(
                  'Cancel',
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
