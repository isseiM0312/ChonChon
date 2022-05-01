import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chonchon/Page6.dart';

class Page5 extends StatefulWidget {
  @override
  _Page5State createState() => new _Page5State();
}

class _Page5State extends State<Page5> {
  late DateTime timeLeft;

  @override
  void initState() {
    const List<int> invDurationArray = [0, 10];
    final invDuration =
        Duration(minutes: invDurationArray[0], seconds: invDurationArray[1]);
    timeLeft = DateTime(0, 0, 0, 0, invDurationArray[0], invDurationArray[1]);
    Timer.periodic(Duration(seconds: 1), setLeftTime);
    Timer(invDuration, handleTimeout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Page5"),
          automaticallyImplyLeading: false,
        ),
        body: Column(children: [
          Text("This page is Page5"),
          Text(
            DateFormat.ms().format(timeLeft),
            style: Theme.of(context).textTheme.headline2,
          )
        ]));
  }

  void setLeftTime(Timer timer) {
    setState(() {
      timeLeft = timeLeft.add(Duration(seconds: -1));
    });
  }

  void handleTimeout() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Page6();
    }));
  }
}
