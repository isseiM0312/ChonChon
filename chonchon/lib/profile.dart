import 'dart:io';

import 'package:chonchon/profile_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //List<String> tags = ["python", "swift", "dart", "flutter"];
  //String tags_string = "python, swift, dart, flutter";
  List<String> stringToList(String listAsString) {
    return listAsString.split(',').toList();
  }

  late List<String> tagList;
  late var _chipList = <Chip>[];

  // tag表示用

  String tagsString = '';

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

  late String uid;

  //firestoreのcollection("users")へのリファレンス
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;

  void getUid() {
    late User? user = auth.currentUser;
    uid = user!.uid;
    // here you write the codes to input the data into firestore
  }

  File? image;

  Future getProfile() async {
    await users.doc(uid).get().then((DocumentSnapshot snapshot) {
      setState(() {
        name = snapshot.get("name");
        major = snapshot.get("major");
        grade = snapshot.get("grade");
        comment = snapshot.get("comment");
        tagsString = snapshot.get("tagsString");
        tagList = stringToList(tagsString);
        _chipList = <Chip>[];
        for (var tag in tagList) {
          if (tag == '') continue;
          _chipList.add(
            Chip(
              label: Text("$tag"),
            ),
          );
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUid();

    Future(() async {
      await getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('マイページ'),
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  new MaterialPageRoute<bool>(
                    builder: (BuildContext context) => ProfileEditPage(),
                  ),
                ).then((value) async {
                  await getProfile();
                });
              }),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Visibility(
              child: Container(
                  height: 150,
                  margin: EdgeInsets.only(top: 25.0, bottom: 25.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  )),
            ),
            Text(
              "名前",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              "${name}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "学部・学科",
              style: TextStyle(
                fontSize: 16,
                height: 2.0, //テキストサイズの2倍
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "${major}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "学年",
              style: TextStyle(
                fontSize: 16,
                height: 2.0, //テキストサイズの2倍
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "${grade}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "一言",
              style: TextStyle(
                fontSize: 16,
                height: 2.0, //テキストサイズの2倍
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "${comment}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Expanded(
            //   child: Container(
            //     width: 300.0,
            //     height: 300.0,
            //     child: Image.asset("assets/images/noimage.png"),
            //   ),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       crossAxisAlignment: CrossAxisAlignment.end,
            //       children: <Widget>[
            //         Text(
            //           "名前 :",
            //           style: TextStyle(
            //             fontSize: 20,
            //             fontWeight: FontWeight.bold
            //           ),
            //         ),
            //         const SizedBox(height: 5),
            //         Text(
            //           "学部・学科 :",
            //           style: TextStyle(
            //             fontSize: 20,
            //             fontWeight: FontWeight.bold,
            //             height: 2.0, //テキストサイズの2倍
            //           ),
            //         ),
            //         const SizedBox(height: 5),
            //         Text(
            //           "学年 :",
            //           style: TextStyle(
            //             fontSize: 20,
            //             fontWeight: FontWeight.bold,
            //             height: 2.0, //テキストサイズの2倍
            //           ),
            //         ),
            //         const SizedBox(height: 5),
            //         Text(
            //           "一言 :",
            //           style: TextStyle(
            //             fontSize: 20,
            //             fontWeight: FontWeight.bold,
            //             height: 2.0, //テキストサイズの2倍
            //           ),
            //         ),
            //       ],
            //     ),
            //     Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: <Widget>[
            //         Text(
            //           "　${name}",
            //           style: TextStyle(
            //             fontSize: 20,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         const SizedBox(height: 5),
            //         Text(
            //           "　${major}",
            //           style: TextStyle(
            //             fontSize: 20,
            //             height: 2.0, //テキストサイズの2倍
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         const SizedBox(height: 5),
            //         Text(
            //           "　${grade}",
            //           style: TextStyle(
            //             fontSize: 20,
            //             height: 2.0, //テキストサイズの2倍
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         const SizedBox(height: 5),
            //         Text(
            //           "　${comment}",
            //           style: TextStyle(
            //             fontSize: 20,
            //             height: 2.0, //テキストサイズの2倍
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            Container(
              padding: EdgeInsets.only(left: 40, top: 5, right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 8.0,
                      runSpacing: 0.0,
                      direction: Axis.horizontal,
                      children: _chipList,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: 200.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
