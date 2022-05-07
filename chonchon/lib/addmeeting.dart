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
 String uid ="";
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
              print("documentID---- " + f.reference.id);
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
      mytag =stringToList(value.get("tagsString")) ;
    });
  }

  addevent() async {
    print("dd");
    await Firebase.initializeApp();
    print("clean");
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
      'maxnum': maxnum,
      'currentNum': 1,
      'tag': finaltag
    });
    print(eventkey);

    print("fin");
  }

  String name = "";
  String reservetime = "";
  String createdtime = "";
  String member = "";
  double maxnum = 0;
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

  void caltimepicker() async {
   await DatePicker.showTimePicker(
      context,
      showTitleActions: true,

      // onChanged内の処理はDatepickerの選択に応じて毎回呼び出される
      onChanged: (date) {
        // print('change $date');
      },
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
            height: 30,
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
                    caltimepicker;
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
                    double hoge;
                    try {
                      hoge = double.parse(value);
                      maxnum = hoge;
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
                    print(taglist);
                    for (var a in taglist) {
                      if (a == tag) {
                        tagooverrapded = true;
                      }
                    }
                    print("cd");
                    print(tagooverrapded);
                    if (tagooverrapded == false) {
                      if (tag != "") {
                        _onSubmitted(tag);
                        print("tintin");
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
        ],
      ))),
      floatingActionButton: Visibility(
          visible: noselecting,
          child: SizedBox(
            child: FloatingActionButton(
                child: Text("作成"),
                heroTag: 40,
                onPressed: () {
                  finaltag = Listtostring(taglist);
                  Future<void> res = addevent();
                  res.then((value) {
                    print("conp");
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Page5(
                      eventkey: eventkey,
                    );
                  }));
                }),
            width: 100,
            height: 100,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}












/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'lunchmeeting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Page5.dart';

Future<void> main() async {
  // Fireabse初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CreateMeet());
}

final FirebaseAuth auth = FirebaseAuth.instance;
late String uid;
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

class _CreateMeetPageState extends State<CreateMeetPage> {
  void coms() async {
    print("start");
    await Firebase.initializeApp();
    print("clean");
    await FirebaseFirestore.instance
        .collection('User')
        .doc('D1GKO8M8XrqA5Dh9Up5T')
        .get()
        .then((value) {
      print(value.get("name"));
    });
    print("finished");
  }

  void addevent() async {
    await Firebase.initializeApp();
    print("clean");
    await FirebaseFirestore.instance.collection("Event").add({
      'host': uid,
      'comment': citchat,
      'eventname': name,
      'reservation_time': time,
      'maxnum': maxnum,
      'tag': tag
    });
    print("fin");
  }

  String name = "";
  String time = "";
  String member = "";
  double maxnum = 0;
  String citchat = "";
  String tag = "";

  @override
  void initState() {
    super.initState();
    getUid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(children: [
                  Text("ミートの名前"),
                  Container(
                    child: TextField(onChanged: (value) => name = value),
                    width: 300,
                  ),
                ]),
                Row(children: [
                  Text("uid"),
                  Container(
                      child: TextField(onChanged: (value) => member = value),
                      width: 300),
                ]),
                Row(
                  children: [
                    Text("集合時間"),
                    Container(
                        child: TextField(
                          onChanged: (value) => time = value,
                        ),
                        width: 300),
                  ],
                ),
                Row(
                  children: [
                    Text("最大人数"),
                    Container(
                        child: TextField(onChanged: (value) {
                          double hoge;
                          try {
                            hoge = double.parse(value);
                            maxnum = hoge;
                          } catch (exception) {}
                        }),
                        width: 300)
                  ],
                ),
                Row(
                  children: [
                    Text("ひとこと"),
                    Container(
                        child: TextField(onChanged: (value) => citchat = value),
                        width: 300),
                  ],
                ),
                Row(
                  children: [
                    Text("タグ"),
                    Container(
                        child: TextField(onChanged: (value) => tag = value),
                        width: 300)
                  ],
                )
              ]),
        ),
        floatingActionButton: Column(children: [
          FloatingActionButton(onPressed: () {
            addevent;
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Page5();
            }));
          }),
          FloatingActionButton(onPressed: (() => Navigator.pop(context)))
        ]));
  }
}
*/