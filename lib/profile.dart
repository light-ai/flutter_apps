import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/login.dart';
import 'package:flutter_app/user.dart';
import 'package:flutter_app/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/calender.dart';
import 'package:flutter_app/addPost.dart';

class ProfilePage extends StatefulWidget {
  // ユーザー情報
  final User user;
  // 引数からユーザー情報を受け取る
  ProfilePage(this.user);

  _ProfilePage createState() => _ProfilePage(this.user);
}

class _ProfilePage extends State<ProfilePage>{
  _ProfilePage(this.user);
  final User user;
  bool isFollowing = false;
  bool followButtonClicked = false;
  ScheduleUser follow;
  User currentUser = FirebaseAuth.instance.currentUser;

  followUser() {
    final profileUserId = user.email;
    print('following user');
    setState(() {
      this.isFollowing = true;
      followButtonClicked = true;
    });

    FirebaseFirestore.instance.collection('users').document(user.email).setData({
      'followers': true,
      'following_$profileUserId': true
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });

    //updates activity feed
    /*Firestore.instance
        .collection("users")
        .document('profile')
        .setData({
      "ownerId": user.email,
      "username": '',
      "userId": '',
      "type": "follow",
      "userProfileImg": '',
      "timestamp": DateTime.now()
    });*/
  }

  unfollowUser() {
    final profileUserId = user.email;
    setState(() {
      isFollowing = false;
      followButtonClicked = true;
    });

    FirebaseFirestore.instance.collection('users').doc(user.email).set({
      'followers': false,
      'following_$profileUserId': false
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });
  }

  /* Firestore.instance
        .collection("users")
        .document('profile')
        .delete();*/

  Follow(dynamic snapshot){
    if (snapshot) {
      return Scaffold(
        appBar: AppBar(
          title: Text('プロフィール'),
        ),
        body: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(
                  currentUser.photoURL
              ),
            ),
            Text(currentUser.displayName),
            RaisedButton(
              child: const Text('Remove'),
              color: Colors.red,
              shape: const StadiumBorder(),
              onPressed: () {
                unfollowUser();
              },
            ),
          ],
        ),
      );

    }
    else if (!snapshot) {
      return Scaffold(
        appBar: AppBar(
          title: Text('プロフィール'),
        ),
        body: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(
                  currentUser.photoURL
              ),
            ),
            Text(currentUser.displayName),
            RaisedButton(
              child: const Text('Follow'),
              color: Colors.red,
              shape: const StadiumBorder(),
              onPressed: () {
                followUser();
              },
            ),
          ],
        ),
      );
    }else{
      return Center(
        child: Text('読み込み中です'),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(user.email).snapshots(),
      builder: (context, snapshot) {
        return Follow(snapshot.data['followers']);
      },
    );
  }
}
