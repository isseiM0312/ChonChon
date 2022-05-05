import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chonchon/Page6.dart';
import 'package:chonchon/Page8.dart';

class Page5 extends StatefulWidget {
  @override
  _Page5State createState() => new _Page5State();
}

class _Page5State extends State<Page5> {
  late DateTime timeLeft;

  var _timer;

  late int counter;

  @override
  void initState() {
    super.initState();
    const List<int> invDurationArray = [3, 20]; //[minutes, seconds]

    final invDuration = Duration(
        minutes: invDurationArray[0],
        seconds: invDurationArray[1]); //set duration

    timeLeft = DateTime(
        0, 0, 0, 0, invDurationArray[0], invDurationArray[1]); //set time left

    _timer = Timer.periodic(Duration(seconds: 1), setLeftTime); //start timer

    Timer(invDuration, handleTimeout); //shift to Page6

    counter = 0;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Event')
            .doc('MDDxz493FtXBziY6xWB7')
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.data != null) {
            if ((int.parse(snapshot.data!['maxnum']) ==
                    int.parse(snapshot.data!['currentNum']) &&
                counter == 0)) {
              counter++;
              handleEventMaking(); //shift to Page8
            }
          }

          return Scaffold(
              appBar: AppBar(
                title: Text(""),
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
              ),
              body: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    const SizedBox(height: 120),
                    Text("Waiting for participants to join...",
                        style: Theme.of(context).textTheme.headline5),
                    const SizedBox(height: 25),
                    Text(
                      DateFormat.ms().format(timeLeft),
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    const SizedBox(height: 50),
                    LinearProgressIndicator(),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () => {},
                      child: const Text('Cancel',
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
        });
  }

  void setLeftTime(Timer timer) {
    setState(() {
      timeLeft = timeLeft.add(Duration(seconds: -1));
    });
  }

  void handleTimeout() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return Page6();
    }));
  }

  void handleEventMaking() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return Page8();
    }));
  }
}
