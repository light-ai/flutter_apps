import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/user.dart';
import 'package:flutter_app/chatPage.dart';

class UserModel{
  UserModel(this.user);
  final User user;
  ScheduleUser userModel;

  Future fetchUser() async{
    final data = FirebaseFirestore.instance.collection('users').doc(user.email);
    final dataSnapshot = await data.get();
    this.userModel = ScheduleUser(dataSnapshot, this.user);
  }
}
