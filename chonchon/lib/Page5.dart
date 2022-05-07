import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chonchon/Page6.dart';
import 'package:chonchon/Page8.dart';
import 'package:chonchon/eventdetail.dart';
import 'package:chonchon/chat.dart';
import 'package:chonchon/lunchmeeting.dart';

class Page5 extends StatefulWidget {
  Page5({
    Key? key,
    required this.eventkey,
  });
  String eventkey;

  @override
  _Page5State createState() => new _Page5State();
}

class _Page5State extends State<Page5> {
  DateTime timeLeft = DateTime.now();

  var _timer;

  int counter = 0;
  int totalsec = 0;
  int min = 0;
  int sec = 0;
  DateTime cre = DateTime.now();

  Future<void> getlimittime(DateTime createdtime) async {
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection("Event")
        .doc(widget.eventkey)
        .get()
        .then((value) {
      createdtime = DateTime.parse(value.get("createdtime"));
      print("hello!");

      print(createdtime);
      totalsec = timecal(createdtime);
      min = extractmin(totalsec);
      sec = totalsec - min * 60;
      int m = min;
      int s = sec;
      min = 59 - m;
      sec = 60 - s;
      print(min);
      print(sec);

      final invDuration = Duration(
          minutes: min, //invDurationArray[0],
          seconds: sec /* invDurationArray[1] */); //set duration

      timeLeft = DateTime(0, 0, 0, 0, min /* invDurationArray[0] */,
          sec /* invDurationArray[1] */); //set time left

      _timer = Timer.periodic(Duration(seconds: 1), setLeftTime); //start timer

      Timer(invDuration, handleTimeout); //shift to Page6

      counter = 0;
    });
  }

  @override
  void initState() {
    super.initState();

    getlimittime(cre);

    //できたら負になった時のエラーキャッチ

    /*  List<int> invDurationArray = []; //[minutes, seconds]
    invDurationArray.add(min);
    invDurationArray.add(sec);
     */
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
            .doc(widget.eventkey)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.data != null) {
            if (((snapshot.data!['currentNum'] >= 1) && counter == 0)) {
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
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection("Event")
                            .doc(widget.eventkey)
                            .delete();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LunchMeetingApp();
                        }));
                      },
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

  int timecal(DateTime d) {
    DateTime now = DateTime.now();
    int i = 0;
    i = now.difference(d).inSeconds;
    return i;
  }

  int extractmin(int totalsec) {
    int ans = 0;
    while (totalsec > 61) {
      totalsec = totalsec - 60;
      ans++;
    }
    return ans;
  }

  void setLeftTime(Timer timer) {
    setState(() {
      timeLeft = timeLeft.add(Duration(seconds: -1));
    });
  }

  void handleTimeout() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Page6(
          eventkey: widget.eventkey,
        );
      }));
    });
  }

  Future handleEventMaking() async {
    print("THAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAt");
    print(widget.eventkey);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Page8(
          eventkey: widget.eventkey,
          
          uid: uid,
        );
      }));
    }) ;
    /* showModalBottomSheet(
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Container(
                          height: 900,
                          child: Container(
                            margin: EdgeInsets.all(30),
                            child: Column(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(top: 100),
                                    child: Text(
                                      "Joined!",
                                      style: TextStyle(
                                          fontSize: 90, color: Colors.white),
                                    )),
                                Container(
                                  height: 50,
                                ),
                                Row(
                                  children: [usericons(), usericons()],
                                ),
                                Container(height: 50),
                                SizedBox(
                                    height: 70,
                                    width: 200,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.orange, // background
                                        onPrimary: Colors.white, // foreground
                                      ),
                                      onPressed: () => Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ChatPage("チャット");
                                      })),
                                      child: Text(
                                        'チャット',
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    ))
                              ],
                            ),
                            //  Navigator.pop(context),
                            //color: Colors.grey.withOpacity(0.5),
                          ));
                    },
                  );
  }
}
Widget usericons() {
    return Container(
      margin: EdgeInsets.only(right: 30, left: 30, top: 30),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          Icons.people,
          size: 50,
        ),
        Container(margin: EdgeInsets.all(5), child: Text("ユーザー名"))
      ]),
    ); */
  }
}
