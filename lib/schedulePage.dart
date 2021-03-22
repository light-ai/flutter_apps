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
    User currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('スケジュール'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // 投稿メッセージ一覧を取得（非同期処理）
        // 投稿日時でソート
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(date)
              .collection('schedule')
              .orderBy('year')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<DocumentSnapshot> documents =
                  snapshot.data.docs;
              // 取得した投稿メッセージ一覧を元にリスト表示
              return ListView(
                children: documents.map((document) {
                  IconButton deleteIcon;
                  // 自分の投稿メッセージの場合は削除ボタンを表示
                  if (document['email'] == currentUser.email) {
                  deleteIcon = IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      // 投稿メッセージのドキュメントを削除
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUser.uid)
                          .collection('schedule')
                          .doc(document.id)
                          .delete();
                    },
                  );
                }
                  return Card(
                    child:
                    ListTile(
                      trailing: deleteIcon,
                      title: Text(document['year'] + '  ' + document['day']),
                      subtitle: Text(document['text']),
                      onTap: () => {
                        /*Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          // 引数からユーザー情報を渡す
                          return ProfilePage(document['id']);
                        }),
                      ),*/
                      },
                    ),
                  );
                }).toList(),
              );
            }
            // データが読込中の場合
            return Center(
              child: Text('読込中...'),
            );
          }
      ),
    );
  }
}
