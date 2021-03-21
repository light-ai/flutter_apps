import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/login.dart';
import 'package:flutter_app/profile.dart';
import 'package:flutter_app/schedule_post.dart';
import 'package:flutter_app/ss.dart';
import 'package:flutter_app/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/calender.dart';
import 'package:flutter_app/profile.dart';

//チャット投稿用ウィジェット
class AddPostPage extends StatefulWidget {
  // ユーザー情報
  final User user;
  // 引数からユーザー情報を受け取る
  AddPostPage(this.user);
  @override
  _AddPostPageState createState() => _AddPostPageState(this.user);
}

class _AddPostPageState extends State<AddPostPage> {
  _AddPostPageState(this.user);
  final User user;
  DateTime da;
  String date;
  // 入力した投稿メッセージ
  String messageText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャット投稿'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 投稿メッセージ入力
              TextFormField(
                decoration: InputDecoration(labelText: '投稿メッセージ'),
                // 複数行のテキスト入力
                keyboardType: TextInputType.multiline,
                // 最大3行
                maxLines: 3,
                onChanged: (String value) {
                  setState(() {
                    messageText = value;
                  });
                },
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('投稿'),
                  onPressed: () async {
                    date =
                    DateTime.now().toLocal().toIso8601String(); // 現在の日時
                    final email = widget.user.email; // AddPostPage のデータを参照
                    // 投稿メッセージ用ドキュメント作成
                    await Firestore.instance
                        .collection('posts') // コレクションID指定
                        .document() // ドキュメントID自動生成
                        .setData({
                      'id': user.uid,
                      'text': messageText,
                      'email': email,
                      'date': date,
                      'photoUrl': this.user.photoURL
                    });
                    // 1つ前の画面に戻る
                    Navigator.of(context).pop();
                  },
                ),
              ),
              FloatingActionButton(
                heroTag: 'hero1',
                onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    // 引数からユーザー情報を渡す
                    return CalenderExample(date);
                  }),
                );
              },
              ),
              FloatingActionButton(
                heroTag: 'hero2',
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      // 引数からユーザー情報を渡す
                      return Ss();
                    }),
                  );
                },
              ),
              FloatingActionButton(
                heroTag: 'hero3',
                onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      // 引数からユーザー情報を渡す
                      return SchedulePost(date);
                    }),
                  );
                },
              ),
              /*FloatingActionButton(
                heroTag: 'hero2',
                onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    // 引数からユーザー情報を渡す
                    return ProfilePage(user.uid);
                  }),
                );
              },
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}