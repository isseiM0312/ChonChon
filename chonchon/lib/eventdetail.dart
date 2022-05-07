import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'lunchmeeting.dart';
import 'package:flutter/rendering.dart';
import 'chat.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  // Fireabse初期化
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

final FirebaseAuth auth = FirebaseAuth.instance;
String uid = "";
void getUid() async {
  late User? user = auth.currentUser;
  uid = user!.uid;
}

String eventkey = "";
String a = "";
bool showornot = false;

class EventdetailPage extends StatefulWidget {
  EventdetailPage(
      {Key? key,
      required this.title,
      required this.thiseventkey,
      required this.thiseventname})
      : super(key: key);

  final String title;
  final String thiseventkey;
  final String thiseventname;
  //child: Text(widget.thiseventkey)

  @override
  State<EventdetailPage> createState() => _EventdetailPageState();
}

class _EventdetailPageState extends State<EventdetailPage> {
  Widget usericons() {
    return Container(
      margin: EdgeInsets.only(right: 30, left: 30, top: 30),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          Icons.people,
          size: 50,
        ),
        Container(margin: EdgeInsets.all(5), child: Text("ユーザー名"))
      ]),
    );
  }

  Widget eventinfo(String title, String value) {
    return Container(
      width: 400,
      child: Column(children: [
        Container(
          margin: EdgeInsets.only(left: 10),
          alignment: Alignment.centerLeft,
          width: 400,
          child: Text(title),
        ),
        Center(
          child: Container(
            width: 350,
            height: 50,
            margin: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Text(value),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          ),
        ),
      ]),
    );
  }

  Future<void> executeAfterBuild() async {
    await checkfirestore(widget.thiseventkey);

    setState(() {});
  }

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
                setState(() {
                  showornot = true;
                });
              }
            }),
          },
        );
    /*  await FirebaseFirestore.instance
        .collection("Event")
        .where('', whereIn: [uid])
        .get()
        .then(
          (QuerySnapshot snapshot) => {
            snapshot.docs.forEach((f) {
              print("documentID---- " + f.reference.id);
              list.add(f.reference.id);
              if (list != []) {
                setState(() {
                  showornot = true;
                  print("jsfkhgjhghshgkhkfjhsklhjfhklvsjfhlhfk");
                });
              }
            }),
          },
        ); */
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      mytag = stringToList(value.get("tagsString"));
    });
  }

  @override
  void initState() {
    super.initState();
    getUid();
    myeventsearch();
    setState(() {
      checkfirestore(widget.thiseventkey);
    });
  }

  Widget build(BuildContext context) {
    executeAfterBuild();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(//ユーザーとイベントデータ
          children: [
        Container(
            margin: EdgeInsets.all(30),
            child: Column(
              children: [
                Text("Member"),
                Row(
                  children: [usericons(), usericons()],
                )
              ],
            )),
        Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            eventinfo("Time", "  " + re),
            eventinfo("Max", "  " + "s"),
            eventinfo("Tags", "  " + bluetag(tags))
          ],
        ))
      ]),
      floatingActionButton: SizedBox(
          height: 120,
          width: 120,
          child: FloatingActionButton(
              child: Text(
                "参加する！",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Future<void> res = whenjoin(widget.thiseventkey);
                res.then((res) {
                  showModalBottomSheet(
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Container(
                          height: 900,
                          child: Container(
                            margin: EdgeInsets.all(30),
                            child: Column(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(top: 100),
                                    child: Text(
                                      "Joined!",
                                      style: TextStyle(
                                          fontSize: 90, color: Colors.white),
                                    )),
                                Container(
                                  height: 50,
                                ),
                                Row(
                                  children: [usericons(), usericons()],
                                ),
                                Container(height: 50),
                                SizedBox(
                                    height: 70,
                                    width: 200,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.orange, // background
                                        onPrimary: Colors.white, // foreground
                                      ),
                                      onPressed: () => Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ChatPage(
                                          "チャット",
                                          eventkey: widget.thiseventkey,
                                          uid: uid,
                                        );
                                      })),
                                      child: Text(
                                        'チャット',
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ))
                              ],
                            ),
                            //  Navigator.pop(context),
                            //color: Colors.grey.withOpacity(0.5),
                          ));
                    },
                  );
                });
              })),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

String re = "";
String name = "チャット";
List tags = [];
String members = "";
var curnum;

String bluetag(List tag) {
  String ans = "";
  for (var e in tag) {
    ans = ans + " #" + e;
  }
  return ans;
}

Future checkfirestore(String d) async {
  await Firebase.initializeApp();
  await FirebaseFirestore.instance
      .collection("Event")
      .doc(d)
      .get()
      .then((value) {
    // someevent.users = value.get("Users");
    re = value.get("reservation_time");
    name = value.get("eventname");
    tags = stringToList(value.get("tag"));
    members = value.get("members");
    curnum = int.parse(value.get("currentNum"));
  });
}

whenjoin(String d) async {
  await FirebaseFirestore.instance.collection("Event").doc(d).update(
      {"members": members + "," + uid, "currentNum": (curnum + 1).toString()});
}
