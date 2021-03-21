import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/chatPage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/schedule.dart';

class ScheduleModel extends ChangeNotifier{
  ScheduleModel(this.date);
  String date;
  Schedule schedule;
  User currentUser = FirebaseAuth.instance.currentUser;

  Future fetchSchedule() async{
    final data = FirebaseFirestore.instance.collection('users').doc(currentUser.uid).collection('schedule').doc(date);
    final dataSnapshot = await data.get();
    this.schedule = Schedule(dataSnapshot);
    notifyListeners();
  }
}
