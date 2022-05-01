import 'package:flutter/material.dart';
import 'package:chonchon/Page5.dart';

class Page6 extends StatefulWidget {
  @override
  _Page6State createState() => new _Page6State();
}

class _Page6State extends State<Page6> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Page6"),
          automaticallyImplyLeading: false,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF0D47A1),
                              Color(0xFF1976D2),
                              Color(0xFF42A5F5),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 20, right: 70, left: 70),
                        primary: Colors.white,
                        textStyle: const TextStyle(fontSize: 30),
                      ),
                      onPressed: () => {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return Page5();
                        }))
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF0D47A1),
                              Color(0xFF1976D2),
                              Color(0xFF42A5F5),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 20, right: 70, left: 70),
                        primary: Colors.white,
                        textStyle: const TextStyle(fontSize: 30),
                      ),
                      onPressed: () {},
                      child: const Text('Quit'),
                    ),
                  ],
                ),
              ),
            ])));
  }
}
