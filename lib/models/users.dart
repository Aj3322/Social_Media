

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/models/users.dart';

class Users{
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List   followers;
  final List   following;

  const Users(
  { required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "uid": uid,
    "photoUrl": photoUrl,
    "username": username,
    "bio": bio,
    "followers": followers,
    "following": following,
  };

  static Users fromSnap(DocumentSnapshot snapshot){
    return Users(email: (snapshot.data() as Map<String,dynamic>)['email'],
    uid: (snapshot.data() as Map<String,dynamic>)['uid'],
    photoUrl: (snapshot.data() as Map<String,dynamic>)['photoUrl'],
    username: (snapshot.data() as Map<String,dynamic>)['username'],
    bio: (snapshot.data() as Map<String,dynamic>)['bio'],
    followers: (snapshot.data() as Map<String,dynamic>)['followers'],
    following: (snapshot.data() as Map<String,dynamic>)['following']);
  }
}

