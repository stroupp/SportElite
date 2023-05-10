import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as dev;

class NotifiedUser {
  String lastMessage;
  String unSeenMessageCount;

  NotifiedUser(this.lastMessage, this.unSeenMessageCount);

  getLastMessage() async {
    var currentUserID = FirebaseAuth.instance.currentUser?.uid;

    final res = await FirebaseFirestore.instance
        .collection("chatrooms")
        .get()
        .then(
          (val) {},
        )
        .onError(
      (error, stackTrace) {
        dev.log(
          "[Dashboard Interactor]: Program Get Request",
          error: error,
          stackTrace: stackTrace,
        );
        return Future.error("Error getting program");
      },
    );
    return res;
  }
}
