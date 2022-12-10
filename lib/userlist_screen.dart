import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/constance.dart';
import 'package:flutter_chat_demo/message_list.dart';
import 'package:flutter_chat_demo/model/UserList.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  Widget build(BuildContext context) {
    List<UserList> userList = [
      UserList('Jack john', 1),
      UserList('Smith david', 2),
      UserList('Jordan thomas', 3),
      UserList('Mary morgan', 4),
      UserList('Taylor paul', 4),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 50,
              color: Color(0xff009788),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  children: [
                    IconButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.arrow_back)),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        'chat',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
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
              child: ListView.builder(
                  itemCount: userList.length - 1,
                  itemBuilder: (context, index) {
                    if (Constance.login_id == userList[index].userId) {
                      {
                        userList.remove(userList[index]);
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MessageList(
                                  user_id: userList[index].userId,
                                  userName:
                                      userList[index].userName.toString()),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              ClipOval(
                                child: Material(
                                  color: Colors.grey[200], // Button color
                                  child: InkWell(
                                    onTap: () {},
                                    child: SizedBox(
                                      width: 45,
                                      height: 45,
                                      child: Icon(Icons.person,
                                          size: 30, color: Color(0xff009788)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  userList[index].userName.toString(),
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
