import 'package:chonchon/lunchmeeting.dart';
import 'package:chonchon/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'bottomnavigationbar.dart';
import 'package:chonchon/profile.dart';
import 'package:chonchon/profile_edit.dart';

// ログイン画面用Widget
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*  appBar: AppBar(
        title: const Text("Log in"),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        elevation: 0,
      ), */
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // メールアドレス入力
                TextFormField(
                  decoration: InputDecoration(labelText: 'メールアドレス'),
                  onChanged: (String value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                // パスワード入力
                TextFormField(
                  decoration: InputDecoration(labelText: 'パスワード'),
                  obscureText: true,
                  onChanged: (String value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  // メッセージ表示
                  child: Text(infoText),
                ),
                Container(
                  width: double.infinity,
                  // ユーザー登録ボタン
                  child: ElevatedButton(
                    child: Text('ユーザー登録'),
                    onPressed: () async {
                      try {
                        // メール/パスワードでユーザー登録
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        await auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        // ユーザー登録に成功した場合
                        // プロフィール画面に遷移＋ログイン画面を破棄
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return ProfileEditPage();
                          }),
                        );
                      } catch (e) {
                        // ユーザー登録に失敗した場合
                        setState(() {
                          infoText = "登録に失敗しました：${e.toString()}";
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  // ログイン登録ボタン
                  child: OutlinedButton(
                    child: Text('ログイン'),
                    onPressed: () async {
                      try {
                        // メール/パスワードでログイン
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        await auth.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        // ログインに成功した場合
                        // 掲示板画面に遷移＋ログイン画面を破棄
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return BottomBar();
                          }),
                        );
                      } catch (e) {
                        // ログインに失敗した場合
                        setState(() {
                          infoText = "ログインに失敗しました：${e.toString()}";
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
