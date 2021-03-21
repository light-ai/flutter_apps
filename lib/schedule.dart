import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Schedule{
  final User currentUser = FirebaseAuth.instance.currentUser;
  Schedule(DocumentSnapshot doc){
    this.day = doc.data()['day'];
    this.year = doc.data()['year'];
    this.scheduleMessage = doc.data()['text'];
    this.date = doc.data()['date'];
  }
  String day;
  String year;
  String scheduleMessage;
  String date;
}
