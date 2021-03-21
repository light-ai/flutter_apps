import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/schedule.dart';
import 'package:flutter_app/schedule_model.dart';
import 'package:flutter_app/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/schedule_post.dart';


class SchedulePage extends StatelessWidget {
  SchedulePage(this.date);
  String date;
  @override
  Widget build(BuildContext context) {
    Schedule schedule = context.select<ScheduleModel, Schedule>((model) => model.schedule);
    if(schedule.date.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Calender Example"),
        ),
        body: Row(
          children: [
            Column(
              children: [
                  Text(schedule.year),
                  Text(schedule.day),
                  Text(schedule.scheduleMessage),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                // 引数からユーザー情報を渡す
                return SchedulePost(this.date);
              }),
            );
          },
        ),
      );
    }else if(schedule.date.isEmpty){
      return Scaffold(
        appBar: AppBar(
          title: Text("Calender Example"),
        ),
        body: Row(
          children: [
            Column(
              children: [

              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                // 引数からユーザー情報を渡す
                return SchedulePost(this.date);
              }),
            );
          },
        ),
      );
    }
  }
}
