import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
    const List<int> invDurationArray = [0, 20]; //[minutes, seconds]

    final invDuration = Duration(
        minutes: invDurationArray[0],
        seconds: invDurationArray[1]); //set duration

    timeLeft = DateTime(
        0, 0, 0, 0, invDurationArray[0], invDurationArray[1]); //set time left

    _timer = Timer.periodic(Duration(seconds: 1), setLeftTime); //start timer

    Timer(invDuration, handleTimeout); //shift to Page6
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // initApp();
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Event')
            .doc('MDDxz493FtXBziY6xWB7')
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.data != null) {
            if (int.parse(snapshot.data!['maxnum']) <=
                int.parse(snapshot.data!['currentNum'])) {
              handleEventMaking(); //shift to Page8
            }
          }

          return Scaffold(
              appBar: AppBar(
                title: Text("Page5"),
                automaticallyImplyLeading: false,
              ),
              body: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(
                      DateFormat.ms().format(timeLeft),
                      style: Theme.of(context).textTheme.headline1,
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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Page8()));
    });
  }
}
