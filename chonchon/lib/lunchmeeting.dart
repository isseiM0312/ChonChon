import 'package:chonchon/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'eventdetail.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Page5.dart';

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

class event {
  //イベントクラスの定義
  String document = "";
  List users = [];
  String eventname = "";
  String time = "";
  int matchtag = 0;
  List<String> tag = [];
  double curnum = 0;
  double maxnum = 0;

  //event({this.document, this.users, this.eventname, this.time});
}

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

List events = []; //eventクラスを格納するリス
const List fields = ["Users", "eventname", "reservation_time"]; //docの下階層の奴の一覧
List mytag = ["#python"];
List searchtag = [];
late List l = [];

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
        .then((value) async {
      // someevent.users = value.get("Users");
      someevent.time = value.get("reservation_time");
      someevent.eventname = value.get("eventname");

      someevent.tag = stringToList(value.get("tag"));
      // someevent.curnum = value.get("currentNum");
      // someevent.maxnum = value.get("maxnum");
      print(someevent.users);

      //タグを追加→arrayなのでgetできない
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
//タグ検索
  void reloadbytag(List mytag) {
    //カウンタ初期化
    for (var instance in events) {
      instance.matchtag = 0;
    }
    for (String element in mytag) {
      for (var instance in events) {
        for (var tag in instance.tag) {
          print(tag);
          print(element);
          if (tag == element) {
            instance.matchtag++;
            print("object");
            print(instance.matchtag);
          }
        }
      }
    }
    print("konni");

    events.sort(((a, b) => b.matchtag.compareTo(a.matchtag)));
    setState(() {
      events = [...events];
    });
  }

  //今あるイベントのウィジェットづくり
  void makewidget(List nowevent) async {
    items = [];
    for (var e in nowevent) {
      addwidget(e);
    }

    if (items.isEmpty) {
      setState(() {
        invisibleload = false;
      });
      print("kvfjaojhfakvfj");
    }
  }

  void clicledevent(event e) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(e.eventname),
          content: Column(children: [Text(e.document), Text(e.tag.toString())]),
          actions: <Widget>[
            // ボタン領域
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Future testforimg() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference imageRef = storage.ref().child("じじい.png");
    String imageUrl = await imageRef.getDownloadURL();
    _img = Image.network(imageUrl);
  }

  Image? _img;
  void addwidget(event e) {
    /* if (e.curnum != e.maxnum) { */
    items.add(GestureDetector(
        onTap: () {
          //各予約をタップしたときの奴
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EventdetailPage(
              title: e.eventname,
              thiseventkey: e.document,
              thiseventname: e.eventname,
            );
          }));
          //clicledevent(e);
          setState(() {});
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, border: Border.all(color: Colors.black)),
          margin: EdgeInsets.all(5),
          alignment: Alignment.center,
          height: 100,
          width: 100,
          child: Row(
            children: [
              Container(
                  margin: EdgeInsets.all(20),
                  height: 50,
                  width: 50,
                  color: Colors.blue),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(e.eventname),
                Text(
                  Listtostring(e.tag),
                  style: TextStyle(color: Colors.lightBlue),
                )
              ])
              //これがボックスのタイトル
            ],
          ),
        )));
  }

  var selectedcolor = Colors.black;

  bool _searchBoolean = false;

  Widget _searchTextField() {
    return TextField(
        onChanged: (value) {
          searchtag = [];
          searchtag.add(value);
          if (value == "fav") {
            searchtag = mytag;
          }
          reloadbytag(searchtag);
        },
        autofocus: true, //TextFieldが表示されるときにフォーカスする（キーボードを表示する）
        cursorColor: Colors.white, //カーソルの色
        style: TextStyle(
          //テキストのスタイル
          color: Colors.white,
          fontSize: 20,
        ),
        textInputAction: TextInputAction.search, //キーボードのアクションボタンを指定
        decoration: InputDecoration(
            //TextFiledのスタイル
            enabledBorder: UnderlineInputBorder(
                //デフォルトのTextFieldの枠線
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: UnderlineInputBorder(
                //TextFieldにフォーカス時の枠線
                borderSide: BorderSide(color: Colors.white)),
            hintText: 'Search', //何も入力してないときに表示されるテキスト
            hintStyle: TextStyle(
              //hintTextのスタイル
              color: Colors.white60,
              fontSize: 20,
            )));
  }

  Future<void> executeAfterBuild() async {
    Future<void> res = checkfirestore();
    res.then((res) {
      items = [];
      makewidget(events);
      print("jhgdia");
      setState(() {
        reloadbytag(mytag);
      });
    });

    setState(() {});
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid = "";
  void getUid() async {
    late User? user = auth.currentUser;
    uid = user!.uid;
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
              print("documentID---- " + f.reference.id);
              list.add(f.reference.id);
              if (list != []) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  print("thiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiis");
                  print(list[0].toString());
                  return Page5(
                    eventkey: list[0].toString(),
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

  bool invisibleload = true;
  @override
  void initState() {
    super.initState();
    getUid();

    setState(() {
      executeAfterBuild();
      myeventsearch();

      print(invisibleload);
      print(items);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_searchBoolean ? Text(widget.title) : _searchTextField(),
        actions: !_searchBoolean
            ? [
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _searchBoolean = true;
                      });
                    })
              ]
            : [
                IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchBoolean = false;
                      });
                    })
              ],
        backgroundColor: Colors.blue,
        toolbarHeight: 70,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Visibility(
            visible: invisibleload,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator(), Text("Now loading...")],
            )),
          ),
          Center(
            child: SingleChildScrollView(
                child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: items,
              ),
            )),
          )
        ],
      )
      //,]),
      ,
      /* bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          notchMargin: 6.0,
          child: Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.house,
                        color: selectedcolor,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedcolor = Colors.white;
                        });
                      }),
                  Container(width: 120),
                  Icon(Icons.add),
                  Container(width: 120),
                  Icon(Icons.people)
                ],
              )),
        ),*/

      /* floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              heroTag: "s",
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
          FloatingActionButton(
            heroTag: "3",
            onPressed: () {
              reloadbytag(mytag);
              makewidget(events);
              setState(() {});
            },
            child: Icon(Icons.circle),
          ),
          FloatingActionButton(onPressed: () => {Navigator.pop(context)})
        ]) */
    );
  }
}























/*
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'profile.dart';

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
      floatingActionButton:Column(
        verticalDirection: VerticalDirection.up,
        mainAxisSize: MainAxisSize.min,
        children:[
          FloatingActionButton(
            heroTag: "issei",
            child: (Icon(Icons.abc)),
            backgroundColor: Colors.pink,
            onPressed: () {
            Future<void> res = checkfirestore();
            res.then((res) {
              items = [];
              makewidget(events);
              print("jhgdia");
              setState(() {});
            });
          }),
          Container(
            margin: EdgeInsets.only(bottom:16.0),
            child: FloatingActionButton(
              heroTag: "profile",
              child: Icon(Icons.face),
              backgroundColor: Colors.green,
              onPressed: () => {Navigator.push(context,
               MaterialPageRoute(builder: ((context) {
                return MyApp2();
              })))},
            )),
           ]),
    );
  }
}

*/