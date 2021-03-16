import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/login.dart';
import 'package:flutter_app/profile_edit.dart';
import 'package:flutter_app/user.dart';
import 'package:flutter_app/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/calender.dart';
import 'package:flutter_app/addPost.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage(this.profileId);
  String profileId;
  _ProfilePage createState() => _ProfilePage(profileId);
}

class _ProfilePage extends State<ProfilePage>{
  _ProfilePage(this.profileId);
  String profileId;
  bool isFollowing = false;
  bool followButtonClicked = false;
  ScheduleUser follow;
  User currentUser = FirebaseAuth.instance.currentUser;

  followUser() {
    final profileUserId = currentUser.email;
    setState(() {
      this.isFollowing = true;
      followButtonClicked = true;
    });
    FirebaseFirestore.instance.collection('users').doc(currentUser.email).update({
      'following': true,
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });

    FirebaseFirestore.instance.collection('users').doc(profileId).update({
      'followers': true
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

  followUsers() {
    final profileUserId = currentUser.email;
    print('following user');
    setState(() {
      this.isFollowing = true;
      followButtonClicked = true;
    });
    FirebaseFirestore.instance.collection('users')
        .doc(currentUser.email)
        .set({
      'following.$profileId': false,
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });

    FirebaseFirestore.instance.collection('users').doc(profileId).set({
      'followers.$profileUserId': false
    });
  }

  unfollowUser() {
    final profileUserId = currentUser.email;
    setState(() {
      isFollowing = false;
      followButtonClicked = true;
    });
    FirebaseFirestore.instance.collection('users').doc(currentUser.email).update({
      'following': false,
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });

    FirebaseFirestore.instance.collection('users').doc(profileId).update({
      'followers': false
    });
  }

  unfollowUsers() {
    final profileUserId = currentUser.email;
    setState(() {
      isFollowing = false;
      followButtonClicked = true;
    });
    FirebaseFirestore.instance.collection('users').doc(currentUser.email).set({
      'following.$profileId': false,
      //firestore plugin doesnt support deleting, so it must be nulled / falsed
    });

    FirebaseFirestore.instance.collection('users').doc(profileId).set({
      'followers.$profileUserId': false
    });
  }

  void GetInfo(DocumentSnapshot documentSnapshot) async{
    documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser.email)/*.collection('follow').doc(profileId)*/.get();
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
                  snapshot.data['photoUrl']
              ),
            ),
            Text(snapshot.data['text']),
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
                  snapshot.data['photoUrl']
              ),
            ),
            Text(snapshot.data['text']),
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
    String email = currentUser.email;
    QueryDocumentSnapshot documentSnapshot;
    GetInfo(documentSnapshot);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(profileId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data['followers']) {
          return Scaffold(
            appBar: AppBar(
              title: Text('プロフィール'),
            ),
            body: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      snapshot.data['photoUrl']
                  ),
                ),
                Text(snapshot.data['text']),
                RaisedButton(
                  child: const Text('Remove'),
                  color: Colors.red,
                  shape: const StadiumBorder(),
                  onPressed: () {
                    unfollowUser();
                  },
                ),
                Text(snapshot.data['msg']),
                OutlinedButton(
                  child: const Text('Edit Profile'),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return ProfileEdit();
                      }),
                    );
                  },
                ),
              ],
            ),
          );
        }
        else if (!snapshot.data['followers']) {
          return Scaffold(
            appBar: AppBar(
              title: Text('プロフィール'),
            ),
            body: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      snapshot.data['photoUrl']
                  ),
                ),
                Text(snapshot.data['text']),
                RaisedButton(
                  child: const Text('Follow'),
                  color: Colors.red,
                  shape: const StadiumBorder(),
                  onPressed: () {
                    followUser();
                  },
                ),
                Text(snapshot.data['msg']),
                OutlinedButton(
                  child: const Text('Edit Profile'),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return ProfileEdit();
                      }),
                    );
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
      },
    );
  }
}
