import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/calender.dart';
import 'package:flutter_app/profile_edit.dart';
import 'package:flutter_app/user.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage(this.profileId);
  String profileId;
  _ProfilePage createState() => _ProfilePage(profileId);
}

class _ProfilePage extends State<ProfilePage>{
  _ProfilePage(this.profileId);
  String profileId;
  bool isFollowing = true;
  ScheduleUser follow;
  User currentUser = FirebaseAuth.instance.currentUser;

  Future<void> checkExistence() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(profileId)
        .get();

    final exists = await doc.data()['followers'].containsKey(currentUser.uid);
    if(!exists){
      final currentUserId = currentUser.uid;

      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
        'following.$profileId': false,
      });

      await FirebaseFirestore.instance.collection('users').doc(profileId).update({
        'followers.$currentUserId': false
      });
    }
  }

  followUser() {
    final currentUserId = currentUser.uid;
    setState(() {
      //this.isFollowing = true;
    });
    FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
      'following.$profileId': true,
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });

    FirebaseFirestore.instance.collection('users').doc(profileId).update({
      'followers.$currentUserId': true
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
    final currentUserId = currentUser.uid;
    setState(() {
      //isFollowing = true;
    });
    FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
      'following.$profileId': false,
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });

    FirebaseFirestore.instance.collection('users').doc(profileId).update({
      'followers.$currentUserId': false
    });
  }

  @override
  Widget build(BuildContext context) {
    OutlinedButton editButton;
    checkExistence();
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(profileId).snapshots(),
      builder: (context, snapshot) {
        final currentUserId = currentUser.uid;

        calender() {
          if (snapshot.data['followers.$currentUserId']) {
            return CalenderExample();
          }else{
            return Column(
              children: <Widget>[
                Text('フォローするとカレンダー見れます'),
                Icon(Icons.add_to_queue_sharp)
              ],
            );
          }
        }

        if (profileId == currentUser.uid) {
          editButton = OutlinedButton(
            child: const Text('Edit Profile'),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return ProfileEdit();
                }),
              );
            },
          );
        }
        else if(snapshot.data['followers'].containsKey(currentUser.uid)) {
          if (isFollowing) {
            if (snapshot.data['followers.$currentUserId']) {
              editButton = OutlinedButton(
                child: const Text('Remove'),
                onPressed: () {
                  unfollowUser();
                },
              );
            } else if (!snapshot.data['followers.$currentUserId']) {
              editButton = OutlinedButton(
                child: const Text('Follow'),
                onPressed: () {
                  followUser();
                },
              );
            }
          }
        }else if(!snapshot.data['followers'].containsKey(currentUser.uid)){
          if (profileId == currentUser.uid) {
            editButton = OutlinedButton(
              child: const Text('Edit Profile'),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return ProfileEdit();
                  }),
                );
              },
            );
          }else {
            editButton = OutlinedButton(
              child: const Text('Follow'),
              onPressed: () {
                followUser();
              },
            );
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('プロフィール'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          snapshot.data['photoUrl'],
                        ),
                      ),
                      Text(snapshot.data['text']),
                      editButton,
                    ],
                  ),
                ),
                Text(snapshot.data['msg']),
              ],
            ),
          ),
        );
      },
    );
  }
}
