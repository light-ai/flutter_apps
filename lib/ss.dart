import 'package:flutter/material.dart';
import 'package:flutter_app/user_model.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Ss extends StatefulWidget {
  @override
  _SsState createState() => _SsState();
}

class _SsState extends State<Ss> {

  a() async{
    final String userName = await context.select<UserModel, String>((model) => model.userModel.name);
    return Text(userName);
  }
  @override
  Widget build(BuildContext context) {
    String userName = context.select<UserModel, String>((model) => model.userModel.name);
    a() async{
      final String userName = await context.select<UserModel, String>((model) => model.userModel.name);
      return Text(userName);
    }

    if(userName == null){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    else if(userName != null){
      return a();
    }
  }
}
