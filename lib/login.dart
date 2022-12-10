import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/userlist_screen.dart';

import 'constance.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  int sender_id = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Login",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child:
                  // Text("priyanka")
                  TextField(
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      controller: _usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter username',
                        hintText: 'Enter username',
                      )),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                  obscureText: true,
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Password',
                    hintText: 'Enter Password',
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (_usernameController.text.toString().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please enter username"),
                      ));
                    } else if (_usernameController.text
                        .toString()
                        .contains("Jack")) {
                      Constance.login_id = 1;
                    } else if (_usernameController.text
                        .toString()
                        .contains('Smith')) {
                      Constance.login_id = 2;
                    } else if (_usernameController.text
                        .toString()
                        .contains('Jordan')) {
                      Constance.login_id = 3;
                    } else if (_usernameController.text
                        .toString()
                        .contains('Mary')) {
                      Constance.login_id = 4;
                    } else if (_usernameController.text
                        .toString()
                        .contains('Taylor')) {
                      Constance.login_id = 4;
                    } else if (_passwordController.text.toString().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please enter password"),
                      ));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserListScreen(),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
