import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/constance.dart';
import 'package:flutter_chat_demo/model/Message.dart';
import 'package:intl/intl.dart';
import 'model/message_dao.dart';

class MessageList extends StatefulWidget {
  final messageDao = MessageDao();

  MessageList({Key? key, required this.user_id, required this.userName})
      : super(key: key);
  final int user_id;
  final String userName;

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  TextEditingController _messageController = TextEditingController();

  List<Message> messageList = [];

  late DatabaseReference typingRef;
  late DatabaseReference typingFinalRef;
  late final DatabaseReference _messagesNodeRef;

  Timer? _debounce;
  Timer? _debounce2;
  String query = "";
  int _debouncetime = 5000;
  int _debouncetime2 = 2000;

  String node = "";
  bool isTyping = false;

  bool isTypingShow = false;

  @override
  void initState() {
    _messageController.addListener(_onSearchChanged);

    if (Constance.login_id > widget.user_id) {
      node = widget.user_id.toString() + "_" + Constance.login_id.toString();
    } else {
      node = Constance.login_id.toString() + "_" + widget.user_id.toString();
    }

    typingRef = FirebaseDatabase.instance
        .reference()
        .child('messages')
        .child(node)
        .child('Typing');

    typingFinalRef =
        typingRef.child(widget.user_id.toString()).child('isTyping');

    _messagesNodeRef = FirebaseDatabase.instance
        .reference()
        .child('messages')
        .child(node)
        .child('msg');

    _getMessageList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage("assets/images/bg.jpg")),
        ),
        child: Column(
          children: [
            Container(
              height: 60,
              color: Color(0xff009788),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      color: Colors.white,
                      icon: Icon(Icons.arrow_back),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 5, top: 5, bottom: 5),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(150),
                      ),
                      child: Icon(Icons.person,
                          size: 25, color: Color(0xff009788)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.userName,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          isTypingShow
                              ? Text(
                                  'isTyping...',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white),
                                )
                              : SizedBox(
                                  height: 3,
                                )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: ListView.builder(
                  itemCount: messageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    //for user
                    if (messageList[index].user_id == Constance.login_id) {
                      return Container(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 8.0, left: 10.0, top: 5.0, bottom: 4.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                            child: FittedBox(
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 12.0,
                                      left: 15.0,
                                      top: 8.0,
                                      bottom: 10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${messageList[index].text}',
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      ),
                                      //time
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 8),
                                        child: Text(
                                          readTimestamp(int.parse(
                                              '${messageList[index].date}')),
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    //for sender
                    else {
                      return Container(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 8.0, left: 50.0, top: 5.0, bottom: 4.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                            child: FittedBox(
                              child: Container(
                                color: Color(0xffe7ffd9),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 5.0,
                                      left: 15.0,
                                      top: 8.0,
                                      bottom: 10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${messageList[index].text}',
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      ),
                                      //time
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 8),
                                        child: Text(
                                          readTimestamp(int.parse(
                                              '${messageList[index].date}')),
                                          style: const TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                      child: TextField(
                        onChanged: (text) {},
                        controller: _messageController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Message',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 15),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        _sendMessage();
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 5, right: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xff009788),
                          borderRadius: BorderRadius.circular(200),
                        ),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void _sendMessage() {
    final message = Message(_messageController.text,
        DateTime.now().millisecondsSinceEpoch.toString(), widget.user_id);

    saveMessageToPerticulerNode(message);
    _messageController.clear();
  }

  void saveMessageToPerticulerNode(Message message) {
    _messagesNodeRef.push().set(message.toJson());
  }

  void _getMessageList() async {
    _messagesNodeRef.onValue.listen((event) {
      final data = event.snapshot.value;

      if (data != null) {
        Map<dynamic, dynamic> map = data;

        messageList.clear();
        map.forEach((key, value) {
          if (!value.toString().contains('Typing')) {
            Message message = Message.fromJson(value);
            messageList.add(message);
          }
        });
        if (mounted) setState(() {});
      }
    });

    typingFinalRef.onValue.listen((event) {
      final data = event.snapshot.value;

      if (data != null) {
        setState(() {
          isTyping = data;
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.removeListener(_onSearchChanged);
    _messageController.dispose();
    super.dispose();
  }

  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm');
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + 'DAY AGO';
      } else {
        time = diff.inDays.toString() + 'DAYS AGO';
      }
    }
    return time;
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: _debouncetime), () {
      print("isTypingShow ${isTypingShow} ");

      setTyping(false);
    });

    if (_debounce2?.isActive ?? false) _debounce2!.cancel();
    _debounce2 = Timer(Duration(milliseconds: _debouncetime2), () {
      setTyping(true);
    });
  }

  void setTyping(bool isTyping) {
    typingRef.set(Constance.login_id);

    Map<String, bool> map1 = {'isTyping': isTyping};

    typingRef.child(Constance.login_id.toString()).set(map1);

    if (isTyping) {
      isTypingShow = true;
    } else {
      isTypingShow = false;
    }
  }
}
