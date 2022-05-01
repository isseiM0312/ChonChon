import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'lunchmeeting.dart';

Future<void> main() async {
  // Fireabse初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CreateMeet());
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
      'Users': member,
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
                  Text("参加者"),
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
          FloatingActionButton(onPressed: addevent),
          FloatingActionButton(onPressed: (() => Navigator.pop(context)))
        ]));
  }
}
