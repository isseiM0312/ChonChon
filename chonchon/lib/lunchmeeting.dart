import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Fireabse初期化
  WidgetsFlutterBinding.ensureInitialized(); //
  await Firebase.initializeApp();
  runApp(LunchMeetingApp());
}

class LunchMeetingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "予定されたミート",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LunchMeetingPage(title: "予定されたミート"),
    );
  }
}

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
  /*.set({
      'event': '合コン',
      'gender': 'male',
      'mail': 'isseieikisouya@outlook.jp',
      'name': '森一晟亜種',
      'studentnumber': 0303030303*/
  print("finished");
}

/*これから書く処理　
・イベントクラスの定義
・checkfirestoreの実装
・読み込み失敗時の実装

*/

class event {
  //イベントクラスの定義
  String document = "";
  List users = [];
  String eventname = "";
  String time = "";

  //event({this.document, this.users, this.eventname, this.time});
}

List events = []; //eventクラスを格納するリスト
const List fields = ["Users", "eventname", "reservation_time"]; //docの下階層の奴の一覧

//checkfirestoreの実装
checkfirestore() async {
  events = [];
  List documents = [];
  print("start");
  await Firebase.initializeApp();
  await FirebaseFirestore.instance
      .collection("Event")
      .get()
      .then((QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach((doc) {
              documents.add(doc.id);
            })
          });
  print("devs");
  for (var document in documents) {
    event someevent = event();
    someevent.document = document;
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection("Event")
        .doc(document)
        .get()
        .then((value) {
      someevent.users = value.get("Users");
      someevent.time = value.get("reservation_time");
      someevent.eventname = value.get("eventname");
    });
    events.add(someevent);
    print(someevent.document);
    print(events);
  }

  print("clean");
}

class LunchMeetingPage extends StatefulWidget {
  LunchMeetingPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _LunchMeetingPageState createState() => _LunchMeetingPageState();
}

class _LunchMeetingPageState extends State<LunchMeetingPage> {
  List<Widget> items = [];

  //今あるイベントのウィジェットづくり
  void makewidget(List nowevent) {
    for (var e in nowevent) {
      addwidget(e.eventname);
      print(e.eventname);
    }
  }

  void addwidget(String boxtitle) {
    items.add(GestureDetector(
        onTap: () {
          //各予約をタップしたときの奴

          setState(() {});
        },
        child: Container(
          margin: EdgeInsets.all(8),
          alignment: Alignment.center,
          height: 100,
          width: 100,
          child: Column(
            children: [
              Text(boxtitle), //これがボックスのタイトル
              Container(
                height: 10,
                width: 20,
                color: Colors.white,
              ),
            ],
          ),
          color: Colors.green.shade200,
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items,
      )),
      floatingActionButton: FloatingActionButton(
          child: (Icon(Icons.abc)),
          onPressed: () {
            Future<void> res = checkfirestore();
            res.then((res) {
              items = [];
              makewidget(events);
              print("jhgdia");
              setState(() {});
            });
          }),
    );
  }
}
