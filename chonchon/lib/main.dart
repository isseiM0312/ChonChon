import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'lunchmeeting.dart';
import 'addmeeting.dart';

/*void main() {
  runApp(const MyApp());
}*/

Future<void> main() async {
  // Fireabse初期化
  WidgetsFlutterBinding.ensureInitialized(); //
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  void getData() {}

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String check = "gsfgvsfd";
  String yourname = "";
  String yourmail = "";

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
              Container(child: Text(check)),
              IconButton(
                onPressed: (() => Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return LunchMeetingApp();
                    })))),
                icon: Icon(Icons.data_array),
              ),
              IconButton(
                  onPressed: ((() => Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CreateMeet();
                      })))),
                  icon: Icon(Icons.abc))
            ]),
      ),
    );
  }
}
