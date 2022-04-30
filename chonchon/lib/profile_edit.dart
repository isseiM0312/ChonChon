import 'package:flutter/material.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
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
        title: Text('編集'),
        actions: [
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                Navigator.pop(context, true);
              }),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //name入力
            TextFormField(
              decoration: InputDecoration(labelText: '名前'),
              onChanged: (String value) {
                setState(() {
                  name = value;
                });
              },
            ),
            //major入力
            TextFormField(
              decoration: InputDecoration(labelText: '学部・学科'),
              onChanged: (String value) {
                setState(() {
                  major = value;
                });
              },
            ),
            //grade入力
            TextFormField(
              decoration: InputDecoration(labelText: '学年'),
              onChanged: (String value) {
                setState(() {
                  grade = value;
                });
              },
            ),
            //comment入力
            TextFormField(
              decoration: InputDecoration(labelText: 'コメント'),
              onChanged: (String value) {
                setState(() {
                  comment = value;
                });
              },
            ),
            Text("tag"),
          ],
        ),
      ),
    );
  }
}
