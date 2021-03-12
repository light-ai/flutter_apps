import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScheduleUser{
  final User user;
  ScheduleUser(DocumentSnapshot doc, this.user){
    this.following = doc.data()['following_' + user.email.toString()];
    this.followed = doc.data()['followers'];
  }
  String id;
  bool following;
  bool followed;
}
