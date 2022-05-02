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
  String tagsString = '';
  late String uid;

  //firestoreのcollection("users")へのリファレンス
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;

  void getUid() {
    late User? user = auth.currentUser;
    uid = user!.uid;
    // here you write the codes to input the data into firestore
  }

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(name),
            Text(major),
            Text(grade),
            Text(comment),
            Row(
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
          ],
        ),
      ),
    );
  }
}
