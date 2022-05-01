import 'package:flutter/material.dart';

void main() => runApp(MyApp2());

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage2(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage2 extends StatefulWidget {
  final String title;

  const MyHomePage2({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<MyHomePage2> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage2> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: const Text("Profile"),
         backgroundColor: Colors.white,
         titleTextStyle: const TextStyle(
           color: Colors.black,
           fontWeight: FontWeight.bold,
           fontSize: 20
           ),
         elevation: 0,
       ),
      body:Center(
        child: Column(
          children: [
            Container(
              height: 150,
              width: 300,
              margin: EdgeInsets.only(top:25.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/icon2.jpg"),
                  fit: BoxFit.contain
                  ),
                shape:BoxShape.circle,
              ),
            ),
            Container(
              height: 25,
              width: 300,
              margin: EdgeInsets.only(top: 10),
              child: Text("Name",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              )
            ),
            Container(
              width: 300,
              height: 100,
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
              child: const Text('Detail',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),)
            ),
          ]),
      ),
    );
  }

}

