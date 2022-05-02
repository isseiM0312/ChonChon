import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  //写真
  String iamge = '';

  // name表示用
  String name = '未設定';

  // major表示用
  String major = '未設定';

  // grade表示用
  String grade = '未設定';

  // comment表示用
  String comment = '未設定';

  late String uid;

  //firestoreのcollection("users")へのリファレンス
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;

  void getUid() async {
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
        print(name);
        print('a');
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
        title: Text('編集'),
        actions: [
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () async {
                final uid = FirebaseAuth.instance.currentUser!.uid;
                print(uid);
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(uid)
                    .set({
                  'name': name,
                  'major': major,
                  'grade': grade,
                  'comment': comment,
                });
                // Firestore.instance.collection("todos")document("1").setData({
                //   "title": "test",
                //   "limitDay": Datetime.now()
                // });
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
              initialValue: name,
              decoration: InputDecoration(labelText: '名前'),
              onChanged: (String value) {
                setState(() {
                  name = value;
                });
              },
            ),
            //major入力
            TextFormField(
              initialValue: major,
              decoration: InputDecoration(labelText: '学部・学科'),
              onChanged: (String value) {
                setState(() {
                  major = value;
                });
              },
            ),
            //grade入力
            TextFormField(
              initialValue: grade,
              decoration: InputDecoration(labelText: '学年'),
              onChanged: (String value) {
                setState(() {
                  grade = value;
                });
              },
            ),
            //comment入力
            TextFormField(
              initialValue: comment,
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
