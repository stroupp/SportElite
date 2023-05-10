import 'package:cloud_firestore/cloud_firestore.dart';
import '../entity/search_by_name_entity.dart';

class SearchByNameInteractor {
  Future<List<User>> fetchTrainers() async {
    List<DocumentSnapshot> documentList = (await FirebaseFirestore.instance
            .collection("users")
            .where("usertype", isEqualTo: "trainer")
            .get())
        .docs;
    List<User> users = [];
    for (var u in documentList) {
      User user = User(
          uid: u["uid"],
          email: u["email"],
          username: u["username"],
          usertype: u["usertype"],
          pp_url: u["pp_url"]);
      users.add(user);
    }
    return users;
  }

  Future<List<User>> fetchAllUsers() async {
    List<DocumentSnapshot> documentList =
        (await FirebaseFirestore.instance.collection("users").get()).docs;
    List<User> users = [];
    for (var u in documentList) {
      User user = User(
          uid: u["uid"],
          email: u["email"],
          username: u["username"],
          usertype: u["usertype"],
          pp_url: u["pp_url"]);

      users.add(user);
    }
    return users;
  }
}
