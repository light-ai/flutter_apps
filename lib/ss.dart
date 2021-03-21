import 'package:flutter/material.dart';
import 'package:flutter_app/user_model.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/user.dart';

class Ss extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScheduleUser user = context.select<UserModel, ScheduleUser>((model) => model.userModel);

    if(user.name == null){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    else if(user.name != null){
      return Text(user.name);
    }
  }
}
