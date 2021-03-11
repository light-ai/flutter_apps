import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/login.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/calender.dart';
import 'package:flutter_app/addPost.dart';

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 右上に表示される"debug"ラベルを消す
      debugShowCheckedModeBanner: false,
      // アプリ名
      title: 'ChatApp',
      theme: ThemeData(
        // テーマカラー
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // ログイン画面を表示
      home: LoginPage(),
      /*initialRoute: "/",
        routes:<String, WidgetBuilder>{
          "/login": (BuildContext context) => LoginPage(),
          "/home": (BuildContext context) => ChatPage(UserState().user),
        }*/
    );
  }
}