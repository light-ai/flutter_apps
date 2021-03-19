import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/chatPage.dart';
import 'package:flutter_app/profile.dart';
import 'package:flutter/cupertino.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  User currentUser = FirebaseAuth.instance.currentUser;
  String profileText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャット'),
      ),
      body: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: '趣味などなど～'),
            onChanged: (String value) {
              setState(() {
                profileText = value;
              });
            },
          ),
          RaisedButton(
            child: const Text('編集完了'),
            onPressed: () {
              FirebaseFirestore.instance.collection('users').doc(
                  currentUser.uid).update({
                'msg': profileText,
              });
              if(profileText == null){
                return showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text('入力値がありません'),
                      content: Text("何か入力してください"),
                      actions: [
                        CupertinoDialogAction(
                          child: Text('すみませんでした'),
                          onPressed: () {
                            Navigator.pop(context);
                            FirebaseFirestore.instance.collection('users').doc(
                                currentUser.uid).update({
                              'msg': "",
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              }else {
                FirebaseFirestore.instance.collection('users').doc(
                    currentUser.uid).update({
                  'msg': profileText,
                });
                return showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text('以下に編集したよ！'),
                      content: Text(profileText),
                      actions: [
                        CupertinoDialogAction(
                          child: Text('ok!'),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                                return ChatPage(currentUser);
                              }),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            splashColor: Colors.purple.shade50,
          ),
        ],
      ),
    );
  }
}
