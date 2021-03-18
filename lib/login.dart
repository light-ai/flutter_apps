import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/chatPage.dart';
import 'package:flutter_app/addPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> _handleSignIn() async {
    GoogleSignInAccount googleCurrentUser = _googleSignIn.currentUser;
    try {
      if (googleCurrentUser == null) googleCurrentUser = await _googleSignIn.signInSilently();
      if (googleCurrentUser == null) googleCurrentUser = await _googleSignIn.signIn();
      if (googleCurrentUser == null) return null;

      GoogleSignInAuthentication googleAuth = await googleCurrentUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);

      await FirebaseFirestore.instance
          .collection('users') // コレクションID指定
          .doc(user.uid) // ドキュメントID自動生成
          .set({
        'id': user.uid,
        'text': user.displayName,
        'email': user.email,
        'photoUrl': user.photoURL,
        'following': false,
        'followers': false,
        'msg': '',
      });

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User> _handleSignIn2() async {
    GoogleSignInAccount googleCurrentUser = _googleSignIn.currentUser;
    try {
      if (googleCurrentUser == null) googleCurrentUser = await _googleSignIn.signInSilently();
      if (googleCurrentUser == null) googleCurrentUser = await _googleSignIn.signIn();
      if (googleCurrentUser == null) return null;

      GoogleSignInAuthentication googleAuth = await googleCurrentUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);

      await FirebaseFirestore.instance
          .collection('users') // コレクションID指定
          .doc(user.uid) // ドキュメントID自動生成
          .update({
        'text': user.displayName,
        'email': user.email,
        'photoUrl': user.photoURL,
      });

      /*await FirebaseFirestore.instance
          .collection('users') // コレクションID指定
          .doc(user.email)
          .collection('follow')
          .doc(user.email)
          .set({

      });*/

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void transitionNextPage(User user) {
    if (user == null) return;

    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        ChatPage(user)
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
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
                child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('ユーザー登録'),
                  onPressed: () async {
                    try {
                      // メール/パスワードでユーザー登録
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final UserCredential result = await auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      final User user = result.user;
                      FirebaseFirestore.instance.collection('users').doc(user.email).set(
                          {
                            'id': user.email
                          });
                      // ユーザー登録に成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          // ユーザー情報を渡す
                          //UserState().setUser(user);
                          return ChatPage(user);
                        }),
                      );
                    } catch (e) {
                      /* --- 省略 --- */
                    }
                  },
                ),
              ),
              Container(
                width: double.infinity,
                // ログイン登録ボタン
                child: OutlineButton(
                  textColor: Colors.blue,
                  child: Text('ログイン'),
                  onPressed: () async {
                    try {
                      // メール/パスワードでログイン
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final UserCredential result = await auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      final User user = result.user;

                      FirebaseFirestore.instance.collection('users').doc(user.email).set({
                        'id': user.email
                      });
                      // ログインに成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          // ユーザー情報を渡す
                          //UserState().setUser(user);
                          return ChatPage(user);
                        }),
                      );
                    } catch (e) {
                      /* --- 省略 --- */
                    }
                  },
                ),
              ),
              Container(
                width: double.infinity,
                // ユーザー登録ボタン
                child:ElevatedButton(
                  child: Text('新規Sign in Google'),
                  onPressed: () {
                    _handleSignIn()
                        .then((User user) =>
                        transitionNextPage(user)
                    )
                        .catchError((e) => print(e));
                  },
                ),
              ),
              Container(
                width: double.infinity,
                // ユーザー登録ボタン
                child:ElevatedButton(
                  child: Text('Sign in Google'),
                  onPressed: () {
                    _handleSignIn2()
                        .then((User user) =>
                        transitionNextPage(user)
                    )
                        .catchError((e) => print(e));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
