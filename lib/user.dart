import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScheduleUser{
  final User user;
  ScheduleUser(DocumentSnapshot doc, this.user){
    this.id = doc.id;
    this.following = doc.data()['following.' + user.uid];
    this.followed = doc.data()['followers'];
    this.name = doc.data()['text'];
  }
  String id;
  String name;
  bool following;
  bool followed;

}
