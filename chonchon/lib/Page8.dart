import 'package:flutter/material.dart';

class Page8 extends StatefulWidget {
  @override
  _Page8State createState() => new _Page8State();
}

class _Page8State extends State<Page8> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Page8"),
          automaticallyImplyLeading: false,
        ),
        body: Text("This page is Page8"));
  }
}
