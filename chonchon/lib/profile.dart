import 'dart:io';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chonchon/profile_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';


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

  String imgPathUse = '';

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
        imgPathUse = snapshot.get("imgPathUse");
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

  final ImagePicker _picker = ImagePicker();
  Image _image = Image.asset("assets/images/noimage.png");
  File? _file;
  Future<void> _downloadFile(String imgPath) async {
    // download path
    await Firebase.initializeApp();
    Reference ref =
        await FirebaseStorage.instance.ref().child('profileImage/$imgPath');
    final String url = await ref.getDownloadURL();
    setState(() {
      _image = Image.network(url);
    });
  }


  @override
  void initState() {
    super.initState();
    getUid();
    Future(() async {
      await getProfile();
      setState(() async {
        await _downloadFile(uid);
      });
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
            if (_image == null)
              Expanded(
                child: Container(
                  width: 150.0,
                  height: 150.0,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: Image.asset("assets/images/noimage.png")),
                ),
              ),
            if (_image != null)
              SizedBox(
                width: 150,
                height: 150,
                child: AspectRatio(aspectRatio: 1,
                 child: ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child:  _image),
               ),
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
