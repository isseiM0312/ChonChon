import 'package:chonchon/profile_edit.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //写真
  String iamge = '';

  // name表示用
  String name = '';

  // major表示用
  String major = '';

  // grade表示用
  String grade = '';

  // comment表示用
  String comment = '';

  // tag表示用

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('マイページ'),
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileEditPage(),
                  ),
                );
              }),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("name"),
            Text("major"),
            Text("grade"),
            Text("comment"),
            Text("tag"),
          ],
        ),
      ),
    );
  }
}
