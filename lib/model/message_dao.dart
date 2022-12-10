import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_demo/model/Message.dart';

class MessageDao {
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.reference().child('messages');

  void saveMessage(Message message) {
    _messagesRef.push().set(message.toJson());
  }

  Query getMessageQuery() {
    return _messagesRef;
  }
}
