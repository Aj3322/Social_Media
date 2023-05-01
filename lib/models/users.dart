
import 'package:cloud_firestore/cloud_firestore.dart';

class Users{
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final bool isOnline;
  final List   followers;
  final List   following;
  final String lastActive;
  late String pushToken;

   Users(
  { required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.isOnline,
    required this.followers,
    required this.following,
    required this.lastActive,
    required this.pushToken,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "uid": uid,
    "photoUrl": photoUrl,
    "username": username,
    "bio": bio,
    "followers": followers,
    "following": following,
    'isOnline': isOnline,
    'lastActive': lastActive,
  };

  static Users fromSnap(DocumentSnapshot snapshot){
    return Users(email: (snapshot.data() as Map<String,dynamic>)['email'],
    uid: (snapshot.data() as Map<String,dynamic>)['uid'],
    photoUrl: (snapshot.data() as Map<String,dynamic>)['photoUrl'],
    username: (snapshot.data() as Map<String,dynamic>)['username'],
    bio: (snapshot.data() as Map<String,dynamic>)['bio'],
    followers: (snapshot.data() as Map<String,dynamic>)['followers'],
    following: (snapshot.data() as Map<String,dynamic>)['following'],
    isOnline:(snapshot.data() as Map<String,dynamic>)['isOnline'],
      lastActive: (snapshot.data() as Map<String,dynamic>)['lastActive'],
      pushToken: (snapshot.data() as Map<String,dynamic>)['pushToken'],);
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      username: map['username'] ?? '',
      uid: map['uid'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      isOnline: map['isOnline'] ?? false,
      email: map['email'],
      bio: map['bio'],
      followers: map['followers'],
      following: map['following'],
      lastActive: map['lastActive'],
      pushToken: map['pushToken'],
    );
  }
}


class ChatUser {ChatUser({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.email,
    required this.pushToken,
  });
  late String image;
  late String about;
  late String name;
  late String createdAt;
  late bool isOnline;
  late String id;
  late String lastActive;
  late String email;
  late String pushToken;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? '';
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }
}
