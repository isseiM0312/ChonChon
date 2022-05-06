import 'package:chonchon/addmeeting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

// flutter_chat_uiを使うためのパッケージをインポート
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:provider/provider.dart';

// ランダムなIDを採番してくれるパッケージ
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
    this.name, {
    Key? key,
    required this.eventkey,
    required this.uid
  }) : super(key: key);
  final String eventkey;
  final String name;
  final String uid;
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  String randomId = Uuid().v4();
  final _user = types.User(id: uid, firstName: '名前');

  void initState() {
    super.initState();
  }

  // firestoreからメッセージの内容をとってきて_messageにセット
  // firestoreからメッセージの内容をとってきて_messageにセット
  void _getMessages() async {
    final getData = await FirebaseFirestore.instance
        .collection('chat_room')
        .doc("チャット")
        .collection(widget.eventkey)
        .get();

    final message = getData.docs
        .map((d) => types.TextMessage(
            author:
                types.User(id: d.data()['uid'], firstName: d.data()['name']),
            createdAt: d.data()['createdAt'],
            id: d.data()['id'],
            text: d.data()['text']))
        .toList();

    setState(() {
      _messages = [...message];
      _messages.sort(
          ((a, b) => b.createdAt!.toInt().compareTo(a.createdAt!.toInt())));
    });
    int d = _messages[0].createdAt ?? 0;
    var s = d.toInt();
    if ((DateTime.now().microsecondsSinceEpoch - d) > 600000) {
      await FirebaseFirestore.instance
          .collection("Event")
          .doc(widget.eventkey)
          .delete();
    }
  }

  // メッセージ内容をfirestoreにセット
  void _addMessage(types.TextMessage message) async {
    setState(() {
      _messages.insert(0, message);
    });
    await FirebaseFirestore.instance
        .collection('chat_room')
        .doc(widget.name)
        .collection(widget.eventkey)
        .add({
      'uid': message.author.id,
      'name': message.author.firstName,
      'createdAt': message.createdAt,
      'id': message.id,
      'text': message.text,
    });
  }

  // リンク添付時にリンクプレビューを表示する
  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  // メッセージ送信時の処理
  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch, //
      id: randomId,
      text: message.text,
    );

    _addMessage(textMessage);
  }

  /*final Stream<QuerySnapshot> stream =
      FirebaseFirestore.instance.collection('posts').snapshots();*/

  String test = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャット'),
      ),
      body: /*Chat(
        theme: const DefaultChatTheme(
          // メッセージ入力欄の色
          inputBackgroundColor: Colors.blue,
          // 送信ボタン
          sendButtonIcon: Icon(Icons.send),
          sendingIcon: Icon(Icons.update_outlined),
        ),
        // ユーザーの名前を表示するかどうか
        showUserNames: true,
        // メッセージの配列
        messages: _messages,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),*/

          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chat_room')
                  .doc(widget.name)
                  .collection(widget.eventkey)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                _getMessages();
                //  return  Text(snapshot.data!.docs[0]["messago0"]);
                /*Message a ;
              
               // return Text(snapshot.data?.documents[0]['userName']);
              //snapshot.data!.docs.map((DocumentSnapshot document) {
                _messages.add(Message a = snapshot.data!.docs[0]["messago0"]);
                print(_messages.toString());
                print("d");

                if (!snapshot.hasData) return const Text('Loading...');
                setState(() {});
              //})
              ;*/
                return Chat(
                  theme: const DefaultChatTheme(
                    // メッセージ入力欄の色
                    inputBackgroundColor: Colors.blue,
                    // 送信ボタン
                    sendButtonIcon: Icon(Icons.send),
                    sendingIcon: Icon(Icons.update_outlined),
                  ),
                  // ユーザーの名前を表示するかどうか
                  showUserNames: true,
                  // メッセージの配列
                  messages: _messages,

                  onPreviewDataFetched: _handlePreviewDataFetched,
                  onSendPressed: _handleSendPressed,
                  user: _user,
                );

                //return Text("");
                /* if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } */

                /* return  
           snapshot.data!.docs.map((DocumentSnapshot document) {
                return Chat(
                  theme: const DefaultChatTheme(
                    // メッセージ入力欄の色
                    inputBackgroundColor: Colors.blue,
                    // 送信ボタン
                    sendButtonIcon: Icon(Icons.send),
                    sendingIcon: Icon(Icons.update_outlined),
                  ),
                  // ユーザーの名前を表示するかどうか
                  showUserNames: true,
                  // メッセージの配列
                  messages: _messages,

                  onPreviewDataFetched: _handlePreviewDataFetched,
                  onSendPressed: _handleSendPressed,
                  user: _user,
                );
              });
            } */
                /* Chat(
        theme: const DefaultChatTheme(
          // メッセージ入力欄の色
          inputBackgroundColor: Colors.blue,
          // 送信ボタン
          sendButtonIcon: Icon(Icons.send),
          sendingIcon: Icon(Icons.update_outlined),
        ),
        // ユーザーの名前を表示するかどうか
        showUserNames: true,
        // メッセージの配列
        messages: _messages,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),*/
              }),
      //floatingActionButton: FloatingActionButton(onPressed: _getMessages),
    );
  }
}
