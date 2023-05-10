import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../chat_screen/entity/message.dart' as msg;
import 'notification_service.dart';

class NotificationUserList {
  int id = 0;
  String channelID = const Uuid().v4();
  NotificationService _notificationService = NotificationService();
  CollectionReference refChats =
      FirebaseFirestore.instance.collection('chatrooms');

  Future<List<String>> getUserList() async {
    var currentID = FirebaseAuth.instance.currentUser?.uid;
    // print("current id -> $currentID");
    List<String> userList = [];
    try {
      CollectionReference col_ref =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot docSnap = await col_ref.get();

      docSnap.docs.forEach((element) {
        if (element.id != currentID) {
          userList.add(element.id);
        }
      });
      return userList;
    } catch (e) {
      return userList;
    }
  }

  Future<void> getLastMessage() async {
    try {
      List<String> userList = await getUserList();
      var currentID = FirebaseAuth.instance.currentUser!.uid;

      userList.forEach((element) async {
        String channelID = Uuid().v4();
        int count = 0;
        String uid = "";
        String username = "";
        String email = "";
        String fullname = returnNameOfChat(element, currentID);
        DocumentSnapshot docCount = await refChats
            .doc(fullname)
            .collection('unseenmessages')
            .doc(currentID)
            .get();
        if (docCount.exists) {
          Map<String, dynamic> data = docCount.data() as Map<String, dynamic>;

          if (data["count"] != null ? data["count"] > 0 : false) {
            count = data["count"];
            DocumentSnapshot docUser = await FirebaseFirestore.instance
                .collection("users")
                .doc(element)
                .get();
            if (docUser.exists) {
              Map<String, dynamic> data =
                  docUser.data() as Map<String, dynamic>;
              uid = data["uid"];
              username = data["username"];
              email = data["email"];

              DocumentSnapshot doc = await refChats
                  .doc(fullname)
                  .collection('unseenmessages')
                  .doc('lastmessage')
                  .get();
              if (doc.exists) {
                msg.Message myMessage = msg.Message.fromDocument(doc);
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                id = id + 1;
                _notificationService.showNotifications(
                    channelID, id, username, myMessage.message, uid, email);

                await refChats
                    .doc(fullname)
                    .collection('unseenmessages')
                    .doc(currentID)
                    .update({"count": 0});
              }
            }
          } else {}
        }
      });
    } catch (e) {}
  }

  String returnNameOfChat(String name1, String name2) {
    int numberr = [name1.length, name2.length].reduce(min);
    for (int i = 0; i < numberr; i++) {
      if (name1[i].codeUnitAt(0) < name2[i].codeUnitAt(0)) {
        return '$name1 _ $name2'.trim();
      } else if (name1[i].codeUnitAt(0) > name2[i].codeUnitAt(0)) {
        return '$name2 _ $name1'.trim();
      }
    }
    return '$name1 _ $name2'.trim();
  }
}
