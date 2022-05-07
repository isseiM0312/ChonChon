import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chonchon/eventdetail.dart';
import 'package:chonchon/chat.dart';


/* void main() {
  runApp(MyApp());
} */

/* class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
} */

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.eventkey}) : super(key: key);
  final String eventkey;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController _pageController;
  int _selectedIndex = 0;

  // ボトムメニューの遷移先画面
  var _pages = [
   EventdetailPage(title: "イベント詳細", thiseventkey: "thiseventkey", thiseventname: "thiseventname")
   ,
   ChatPage(name, eventkey: eventkey, uid: uid)
  ];
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //return LoginPage();

    return Scaffold(
        body: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: _pages));
  }
}