import 'package:flutter/material.dart';
import 'package:chonchon/profile.dart';
import 'package:chonchon/profile_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const MyApp2());
}

class MyApp2 extends StatelessWidget {
  const MyApp2({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyHomePage2(),
    );
  }
}

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage2> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage2> {
  var _selectedValue = 'Language';
  var _usStates = ["Edit", "Language"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        elevation: 0,
        actions: [
          PopupMenuButton(
            initialValue: _selectedValue,
            onSelected: (String s) {
              setState(() {
                _selectedValue = s;
              });
            },
            itemBuilder: (BuildContext contex) {
              return _usStates.map((String s) {
                return PopupMenuItem(
                  child: Text(s),
                  value: s,
                );
              }).toList();
            },
          )
        ],
      ),
      body: Center(
        child: Column(children: [
          Container(
            height: 150,
            margin: EdgeInsets.only(top: 25.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/icon2.jpg"), fit: BoxFit.contain),
              shape: BoxShape.circle,
            ),
          ),
          Container(
              width: 300,
              margin: EdgeInsets.only(top: 10),
              child: Text(
                "Name",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )),
          Container(
              width: 350,
              decoration: BoxDecoration(
                border: const Border(
                  top: const BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                  bottom: const BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
              ),
              alignment: const Alignment(0, 0),
              child: const Text(
                'Detail',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ]),
      ),
    );
  }
}
