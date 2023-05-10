import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/chat_utils.dart';
import '../entity/user.dart';

class FirebaseMessagingService {
  static Stream<List<UserData>> getUsers() {
    try {
      return FirebaseFirestore.instance
          .collection('users')
          .orderBy(UserField.lastMessageTime, descending: true)
          .snapshots()
          .transform(Utils.transformer(UserData.fromDocument));
    } catch (e) {
      return Stream.error("Unable to get users");
    }
  }
}
