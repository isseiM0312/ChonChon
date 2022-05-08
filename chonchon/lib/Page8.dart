import 'package:chonchon/addmeeting.dart';
import 'package:chonchon/eventdetail.dart';
import 'package:flutter/material.dart';
import 'chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String ev = "";

/* class Page8stateless extends StatelessWidget {
  Page8stateless({Key? key, required this.eventkey, required this.uid})
      : super(key: key);
  String eventkey;
  String uid;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Page8(),
      routes: {
        "/test1": (BuildContext context) =>
            ChatPage(name, eventkey: eventkey, uid: uid)
      },
    );
  }
} */

List<String> stringToList(String listAsString) {
  return listAsString.split(',').toList();
}

String Listtostring(List<String> list) {
  String ane = "";
  for (var e in list) {
    ane = ane + "," + e;
  }
  return ane;
}

class Page8 extends StatefulWidget {
  Page8({required this.eventkey, required this.uid});
  String eventkey;
  String uid;
  @override
  _Page8State createState() => new _Page8State();
}

/* class userinfo {
  String uid = "";
  String name = "";
  String iconurl = "";
} */

List<Widget> users = []; //ここに最終的なウィジェットが入る

class _Page8State extends State<Page8> {
  //ユーザ情報導入用
  getuserinfo() async {
    String host = "";
    List members = [];
    List uidlist = [];
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection("Event")
        .doc(widget.eventkey)
        .get()
        .then((value) async {
      host = value.get("host");
      members = stringToList(value.get("members"));
      uidlist = [host, ...members];
      for (String uid in uidlist) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .get()
            .then(((value) {
          users.add(usericons(value.get("name"), value.get("imgPathUse")));
        }));
      }
    });
  }

  void initState() {
    super.initState();
    getuserinfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Page8"),
          automaticallyImplyLeading: false,
        ),
        body: Container(
            color: Colors.grey,
            height: 900,
            child: Container(
              margin: EdgeInsets.all(30),
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 100),
                      child: Text(
                        "Joined!",
                        style: TextStyle(fontSize: 90, color: Colors.white),
                      )),
                  Container(
                    height: 50,
                  ),
                 SingleChildScrollView(
                   scrollDirection: Axis.horizontal,
                   child: Row(children: users)),
                  Container(height: 50),
                  SizedBox(
                      height: 70,
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ChatPage(name,
                                eventkey: widget.eventkey, uid: widget.uid);
                          }));
                        },
                        child: Text(
                          'チャット',
                          style: TextStyle(fontSize: 30),
                        ),
                      ))
                ],
              ),
              //  Navigator.pop(context),
              //color: Colors.grey.withOpacity(0.5),
            )));
  }
}

Widget usericons(String name, String url) {
  return Container(
    margin: EdgeInsets.only(right: 30, left: 30, top: 30),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(
        Icons.people,
        size: 50,
      ),
      Container(margin: EdgeInsets.all(5), child: Text(name))
    ]),
  );
}
