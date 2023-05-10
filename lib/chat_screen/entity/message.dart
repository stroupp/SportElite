import '../../utils/chat_utils.dart';

class MessageField {
  static final String createdAt = 'createdAt';
}

class Message {
  late String message;
  String? sentBy;
  String? isPhoto;
  var timeStamp;

  Message({required this.message, this.timeStamp, this.isPhoto, this.sentBy});

  factory Message.fromDocument(doc) {
    return Message(
        isPhoto: doc['isphoto'],
        message: doc['message'],
        sentBy: doc['sentby'],
        timeStamp: doc['timestamp']);
  }
}
