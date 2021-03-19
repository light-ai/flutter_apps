import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/login.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/calender.dart';
import 'package:flutter_app/addPost.dart';
import 'package:flutter_app/chatApp.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // 最初に表示するWidget
  runApp(ChatApp());
}


/*
class UserState extends ChangeNotifier{
  FirebaseUser user;
  void setUser(FirebaseUser currentUser){
    this.user = currentUser;
    notifyListeners();
  }
}

class LoginCheck extends StatefulWidget{
  LoginCheck({Key key}) : super(key: key);

  @override
  _LoginCheckState createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  //ログイン状態のチェック(非同期で行う)
  void checkUser() async {
    final currentUser = await FirebaseAuth.instance.currentUser();
    final userState = Provider.of<UserState>(context, listen: false);
    if (currentUser == null) {
      @override
      Widget build(BuildContext context) {
        return LoginPage();
      }
    } else {
      userState.setUser(currentUser);
      @override
      Widget build(BuildContext context) {
        return ChatPage(currentUser);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }
  //ログイン状態のチェック時はこの画面が表示される
  //チェック終了後にホーム or ログインページに遷移する
  @override
  Widget build(BuildContext context) {
    checkUser();
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}*/
