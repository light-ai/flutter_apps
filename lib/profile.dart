import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/login.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/calender.dart';
import 'package:flutter_app/addPost.dart';

class ProfilePage extends StatefulWidget {
  // ユーザー情報
  final FirebaseUser user;
  // 引数からユーザー情報を受け取る
  ProfilePage(this.user);

  _ProfilePage createState() => _ProfilePage(this.user);
}

class _ProfilePage extends State<ProfilePage>{
  _ProfilePage(this.user);
  final FirebaseUser user;
  bool isFollowing = false;
  bool followButtonClicked = false;

  followUser() {
    print('following user');
    setState(() {
      this.isFollowing = true;
      followButtonClicked = true;
    });

    Firestore.instance.collection('users').document(user.email).setData({
      'followers': true,
      'following': true
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
    setState(() {
      isFollowing = false;
      followButtonClicked = true;
    });

    Firestore.instance.collection('users').document(user.email).updateData({
      'followers': false,
      'following': false
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });

    Firestore.instance
        .collection("users")
        .document('profile')
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    if (isFollowing) {
      return RaisedButton(
        child: const Text('Remove'),
        color: Colors.red,
        shape: const StadiumBorder(),
        onPressed: () {
          unfollowUser();
        },
      );
    }
    // does not follow user - should show follow button
    if (!isFollowing) {
      return RaisedButton(
        child: const Text('Follow'),
        color: Colors.red,
        shape: const StadiumBorder(),
        onPressed: () {
          followUser();
        },
      );
    }

  }
}
