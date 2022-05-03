import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  // 写真を表示用
  String imgPathUse = '';

  // name表示用
  String name = '未設定';

  // major表示用
  String major = '未設定';

  // grade表示用
  String grade = '未設定';

  // comment表示用
  String comment = '未設定';
  late String uid;

  List<String> stringToList(String listAsString) {
    return listAsString.split(',').toList();
  }

  late List<String> tagList;
  // tag表示用
  String tagsString = '';

  //firestoreのcollection("users")へのリファレンス
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController _name_controller = TextEditingController();
  final TextEditingController _major_controller = TextEditingController();
  final TextEditingController _grade_controller = TextEditingController();
  final TextEditingController _comment_controller = TextEditingController();

  //tag周り
  var _textFieldFocusNode;
  var _inputController = TextEditingController();
  late var _chipList = <Chip>[];
  var _keyNumber = 0;

  get _img => null;

  void getUid() async {
    late User? user = auth.currentUser;
    uid = user!.uid;
    // here you write the codes to input the data into firestore
  }

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
        print(tagsString);
        _chipList = <Chip>[];
        for (var tag in tagList) {
          _addChip(tag);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setLoginInfo();
    _textFieldFocusNode = FocusNode();
  }

  Future<String?> select_icon(BuildContext context) async {
    const String SELECT_ICON = "プロフィール画像を選択";
    const List<String> SELECT_ICON_OPTIONS = ["写真から選択", "写真を撮影"];
    const int GALLERY = 0;
    const int CAMERA = 1;

    var _select_type = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(SELECT_ICON),
            children: SELECT_ICON_OPTIONS.asMap().entries.map((e) {
              return SimpleDialogOption(
                child: ListTile(
                  title: Text(e.value),
                ),
                onPressed: () => Navigator.of(context).pop(e.key),
              );
            }).toList(),
          );
        });

    final picker = ImagePicker();
    var _img_src;

    if (_select_type == null) {
      return null;
    }
    //カメラで撮影
    else if (_select_type == CAMERA) {
      _img_src = ImageSource.camera;
    }
    //ギャラリーから選択
    else if (_select_type == GALLERY) {
      _img_src = ImageSource.gallery;
    }

    PickedFile? pickedFile =
        (await picker.pickImage(source: _img_src)) as PickedFile?;

    if (pickedFile == null) {
      return null;
    } else {
      return pickedFile.path;
    }
  }

  Future<void> uploadFile(String sourcePath, String uploadFileName) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference imageRef = storage.ref().child("images"); //保存するフォルダ

    io.File file = io.File(sourcePath);
    UploadTask task = imageRef.child(uploadFileName).putFile(file);
    String imageUrl = await imageRef.getDownloadURL();
    print(imageUrl);

    try {
      var snapshot = await task;
    } catch (FirebaseException) {
      //エラー処理
    }

    late Image _img;
    // 画面に反映
    setState(() {
      _img = Image.network(imageUrl);
      print(_img);
    });
  }

  Future setLoginInfo() async {
    getUid();
    await getProfile();
    setState(() {
      // _imgPathUse_controller.text = imgPathUse;
      _name_controller.text = name;
      _major_controller.text = major;
      _grade_controller.text = grade;
      _comment_controller.text = comment;
    });
  }

  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  void _onSubmitted(String text) {
    setState(() {
      _inputController.text = '';
      _addChip(text);
      FocusScope.of(context).requestFocus(_textFieldFocusNode);
    });
  }

  void _addChip(String text) {
    if (text == '') return;
    var chipKey = Key('chip_key_$_keyNumber');
    _keyNumber++;

    _chipList.add(
      Chip(
        key: chipKey,
        label: Text(text),
        onDeleted: () => _deleteChip(chipKey),
      ),
    );
  }

  void _deleteChip(Key chipKey) {
    setState(() => _chipList.removeWhere((Widget w) => w.key == chipKey));
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
                tagsString = '';
                for (var chip in _chipList) {
                  Text text = chip.label as Text;
                  tagsString += "${text.data},";
                }

                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(uid)
                    .set({
                  'name': name,
                  'major': major,
                  'grade': grade,
                  'comment': comment,
                  'tagsString': tagsString,
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
            if (_img != null) _img,

            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () async {
                await select_icon(context);
              },
              child: const Text('Enabled'),
            ),
            TextField(
              controller: _name_controller,
              decoration: InputDecoration(labelText: '名前'),
              onChanged: (String value) {
                setState(() {
                  name = value;
                });
              },
            ),
            //major入力
            TextFormField(
              controller: _major_controller,
              decoration: InputDecoration(labelText: '学部・学科'),
              onChanged: (String value) {
                setState(() {
                  major = value;
                });
              },
            ),
            //grade入力
            TextFormField(
              controller: _grade_controller,
              decoration: InputDecoration(labelText: '学年'),
              onChanged: (String value) {
                setState(() {
                  grade = value;
                });
              },
            ),
            //comment入力
            TextFormField(
              controller: _comment_controller,
              decoration: InputDecoration(labelText: 'コメント'),
              onChanged: (String value) {
                setState(() {
                  comment = value;
                });
              },
            ),

            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    focusNode: _textFieldFocusNode,
                    autofocus: true,
                    controller: _inputController,
                    decoration: InputDecoration(
                      hintText: "タグを追加",
                    ),
                    onSubmitted: _onSubmitted,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
