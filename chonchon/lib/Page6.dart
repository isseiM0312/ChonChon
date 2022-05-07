import 'package:chonchon/lunchmeeting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chonchon/Page5.dart';

class Page6 extends StatefulWidget {
  Page6({Key? key, required this.eventkey});
  String eventkey;
  @override
  _Page6State createState() => new _Page6State();
}

class _Page6State extends State<Page6> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("Event")
                      .doc(widget.eventkey)
                      .update({"createdAt": DateTime.now().toString()});
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    return Page5(
                      eventkey: widget.eventkey,
                    );
                  }));
                },
                child: const Text('Try again',
                    style: TextStyle(color: Colors.blueAccent)),
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 20, right: 70, left: 70),
                    textStyle: const TextStyle(fontSize: 30),
                    side: const BorderSide()),
              ),
              const SizedBox(height: 80),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("Event")
                      .doc(widget.eventkey)
                      .delete();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return LunchMeetingApp();
                  }));
                },
                child: const Text('Quit',
                    style: TextStyle(color: Colors.blueAccent)),
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 20, right: 70, left: 70),
                    textStyle: const TextStyle(fontSize: 30),
                    side: const BorderSide()),
              ),
            ])));
  }
}
