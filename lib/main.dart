import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/login.dart';
import 'package:flutter_app/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/calender.dart';
import 'package:flutter_app/addPost.dart';
import 'package:flutter_app/chatApp.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // 最初に表示するWidget
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>(
          create: (context) => UserModel(user)..fetchUser(),
        ),
      ],
      child: MaterialApp(
        title: 'ログイン',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => ChatApp(),
          '/add_quest': (BuildContext context) => LoginPage(),
          '/add_result': (BuildContext context) => LoginPage(),
        },
      ),
    );
  }
}
