class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class UserData {
  final String uid;
  final String? email;
  final String? username;
  final String? imageURL;

  const UserData(
      {required this.uid, required this.email, this.username, this.imageURL});

  factory UserData.fromDocument(doc) {
    return UserData(
        uid: doc['uid'],
        email: doc['email'],
        username: doc["username"],
        imageURL: doc["pp_url"]);
  }
}
