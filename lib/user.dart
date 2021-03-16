import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScheduleUser{
  final User user;
  ScheduleUser(DocumentSnapshot doc, this.user){
    this.id = doc.id;
    this.following = doc.data()['following_' + user.email];
    this.followed = doc.data()['followers'];
    this.id = doc.data()['name'];

  }
  String id;
  bool following;
  bool followed;
}
