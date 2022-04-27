import 'dart:html';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {}

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

class event {
  String eventname = "";
  List users = [];
  String time = "";
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

class LunchMeetingPage extends StatefulWidget {
  LunchMeetingPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _LunchMeetingPageState createState() => _LunchMeetingPageState();
}

class _LunchMeetingPageState extends State<LunchMeetingPage> {
  List<Widget> items = [];
  void addwidget(String boxtitle) {
    items.add(GestureDetector(
        onTap: () {
          //各予約をタップしたときの奴

          setState(() {});
        },
        child: Container(
          margin: EdgeInsets.all(8),
          alignment: Alignment.center,
          height: 500,
          width: 500,
          child: Column(
            children: [
              Text(boxtitle), //これがボックスのタイトル
              Container(
                height: 100,
                width: 200,
                color: Colors.white,
              ),
            ],
          ),
          color: Colors.green,
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
        )));
  }
}
