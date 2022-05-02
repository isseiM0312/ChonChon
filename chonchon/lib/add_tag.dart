import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddTagPage extends StatefulWidget {
  @override
  _AddTagPageState createState() => _AddTagPageState();
}

class _AddTagPageState extends State<AddTagPage> {
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

  final TextEditingController _name_controller = TextEditingController();
  final TextEditingController _major_controller = TextEditingController();
  final TextEditingController _grade_controller = TextEditingController();
  final TextEditingController _comment_controller = TextEditingController();

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
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setLoginInfo();
  }

  Future setLoginInfo() async {
    getUid();
    await getProfile();
    setState(() {
      _name_controller.text = name;
      _major_controller.text = major;
      _grade_controller.text = grade;
      _comment_controller.text = comment;
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
                final uid = await FirebaseAuth.instance.currentUser!.uid;
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
            TextField(
              controller: _name_controller,
              decoration: InputDecoration(labelText: '名前'),
              onChanged: (String value) {
                setState(() {
                  name = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
