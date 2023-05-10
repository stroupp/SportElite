import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../messaging_screen/entity/user.dart';

class UserProvider with ChangeNotifier {
  UserData? myUser;

  defineUser(String uid) async {
    CollectionReference refUsers =
        FirebaseFirestore.instance.collection('users');
    DocumentSnapshot doc = await refUsers.doc(uid).get();
    UserData thisUser = UserData.fromDocument(doc);
    myUser = thisUser;
    notifyListeners();
    return thisUser;
  }
}
