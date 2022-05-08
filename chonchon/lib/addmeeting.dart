import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'lunchmeeting.dart';
import 'package:flutter/rendering.dart';
import 'Page5.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  // Fireabse初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CreateMeet());
}

final FirebaseAuth auth = FirebaseAuth.instance;
String uid = "";
void getUid() async {
  late User? user = auth.currentUser;
  uid = user!.uid;
}

class CreateMeet extends StatelessWidget {
  const CreateMeet({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ミートを追加',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CreateMeetPage(title: 'ミートを追加'),
    );
  }
}

class CreateMeetPage extends StatefulWidget {
  const CreateMeetPage({Key? key, required this.title}) : super(key: key);

  void getData() {}

  final String title;

  @override
  State<CreateMeetPage> createState() => _CreateMeetPageState();
}

List<String> taglist = [];
String eventkey = "";

class _CreateMeetPageState extends State<CreateMeetPage> {
  Future<void> myeventsearch() async {
    List list = [];
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection("Event")
        .where('host', whereIn: [uid])
        .get()
        .then(
          (QuerySnapshot snapshot) => {
            snapshot.docs.forEach((f) {
              list.add(f.reference.id);
              if (list != []) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Page5(
                    eventkey: list[0],
                  );
                }));
              }
            }),
          },
        );
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      mytag = stringToList(value.get("tagsString"));
    });
  }

  addevent() async {
    await Firebase.initializeApp();
    DateTime createddatetime = DateTime.now();
    createdtime = createddatetime.toString();
    /*
    await FirebaseFirestore.instance.collection("Event").add({
      'Users': member,
      'comment': citchat,
      'eventname': name,
      'reservation_time': time,
      'maxnum': maxnum,
      'tag': finaltag
    });
  */

    eventkey = await FirebaseFirestore.instance.collection('Event').doc().id;
    await FirebaseFirestore.instance.collection('Event').doc(eventkey).set({
      'host': uid,
      'members': "",
      'comment': citchat,
      'eventname': name,
      'reservation_time': reservetime,
      'createdtime': createdtime,
      'maxnum': maxnum.toString(),
      'currentNum': "1",
      'tag': finaltag
    });
  }

  String name = "";
  String reservetime = "";
  String createdtime = "";
  String member = "";
  String maxnum = "";
  String citchat = "";
  String tag = "";
  String finaltag = "";
  bool noselecting = true;

  bool tagooverrapded = false;

  var _textFieldFocusNode;
  var _inputController = TextEditingController();
  List<Widget> _chipList = [];
  var _keyNumber = 0;

  @override
  void initState() {
    _textFieldFocusNode = FocusNode();
    super.initState();
    getUid();
    myeventsearch();
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
    var chipKey = Key('chip_key_$_keyNumber');
    _keyNumber++;

    _chipList.add(
      Chip(
        key: chipKey,
        label: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        onDeleted: () {
          _deleteChip(chipKey);
          for (var a in taglist) {
            taglist.remove(text);
          }
        },
        deleteIconColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _deleteChip(Key chipKey) {
    setState(() => _chipList.removeWhere((Widget w) => w.key == chipKey));
  }

  void caltimepicker() {
    DatePicker.showTimePicker(
      context,
      showTitleActions: true,

      // onChanged内の処理はDatepickerの選択に応じて毎回呼び出される
      onChanged: (date) {},
      // onConfirm内の処理はDatepickerで選択完了後に呼び出される
      onConfirm: (date) {
        setState(() {
          reservetime = date.toString();
        });
      },
      // Datepickerのデフォルトで表示する日時
      currentTime: DateTime.now(),
      // localによって色々な言語に対応
      //  locale: LocaleType.en
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 100,
          ),
          Row(children: [
            Container(
                width: 100,
                child: Center(
                  child: Text("ミートの名前"),
                )),
            Container(
              child: TextField(onChanged: (value) => name = value),
              width: 300,
            ),
          ]),
          /*  Row(children: [
              Container(
                width: 100,
                child: Center(
                  child: Text("参加者"),
                ),
              ),
              Container(
                  child: TextField(onChanged: (value) => member = value),
                  width: 300),
            ]), */
          Row(
            children: [
              Container(
                width: 100,
                child: Center(child: Text("集合時間")),
              ),
              Container(child: Text(reservetime), width: 250),
              IconButton(
                  onPressed: () {
                    print("HHHHHHHHHHHHHHHHHHHHHHHHey");
                    caltimepicker();
                  },
                  icon: Icon(Icons.timer))
            ],
          ),
          Row(
            children: [
              Container(
                width: 100,
                child: Center(
                  child: Text("最大人数"),
                ),
              ),
              Container(
                  child: TextField(onChanged: (value) {
                    int hoge;
                    try {
                      hoge = int.parse(value);
                      maxnum = hoge.toString();
                    } catch (exception) {}
                  }),
                  width: 300)
            ],
          ),
          Row(
            children: [
              Container(
                width: 100,
                child: Center(
                  child: Text("ひとこと"),
                ),
              ),
              Container(
                  child: TextField(onChanged: (value) => citchat = value),
                  width: 300),
            ],
          ),
          Row(
            children: [
              Container(
                width: 100,
                child: Center(
                  child: Text("タグ"),
                ),
              ),
              Container(
                  child: TextField(
                      focusNode: _textFieldFocusNode,
                      autofocus: true,
                      controller: _inputController,
                      decoration: InputDecoration(
                        hintText: 'Enter Tag...',
                      ),
                      onSubmitted: _onSubmitted,
                      onChanged: (value) => tag = value),
                  width: 250),
              IconButton(
                  onPressed: (() {
                    tagooverrapded = false;
                    for (var a in taglist) {
                      if (a == tag) {
                        tagooverrapded = true;
                      }
                    }
                    if (tagooverrapded == false) {
                      if (tag != "") {
                        _onSubmitted(tag);
                        taglist.add(tag);
                        tag = "";
                        //ここだとけされたあとのやつになってる
                      } else {}
                    }
                  }),
                  icon: Icon(Icons.add))
            ],
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
          const SizedBox(height: 90),
          ElevatedButton(
            onPressed: () {
              finaltag = Listtostring(taglist);
              Future<void> res = addevent();
              res.then((value) {});
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Page5(
                  eventkey: eventkey,
                );
              }));
            },
            child: const Text('Create new meeting',
                style: TextStyle(color: Colors.blueAccent)),
            style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.only(
                    top: 20, bottom: 20, right: 40, left: 40),
                textStyle: const TextStyle(fontSize: 25),
                side: const BorderSide()),
          ),
        ],
      ))),
    );
  }
}
