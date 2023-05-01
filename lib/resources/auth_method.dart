import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:insta/models/users.dart';
import 'package:flutter/foundation.dart';
import 'package:insta/resources/storageMethod.dart';
import 'package:insta/utils/globleVariable.dart';

class AuthMethods {
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;


  Future<Users> getUserDetails() async {
    User currentuser = _auth.currentUser!;

    DocumentSnapshot snapshot = await _firestore.collection('users').doc(currentuser.uid).get();

    return Users.fromSnap(snapshot);
  }


  Future<String> signUpUser(
      {
        required String email,
        required String password,
        required String username,
        required Uint8List file,
        required String bio,
      }) async{
    String res ="Some error occurred" ;
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty || file != null || bio.isNotEmpty ) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethod().uploadImageToStorage(
            'profilePic', file, false);

        Users users = Users(
            email: email,
            uid: credential.user!.uid,
            photoUrl: photoUrl,
            username: username,
            bio: bio,
            followers:  [],
            following: [],
            isOnline: false,
           lastActive: time,
          pushToken: '',
        );

        await _firestore.collection('users').doc(credential.user!.uid).set(users.toJson());
        res = "success";
      }else{
        res='Pls enter email and password';
      }
    }on FirebaseException catch(err){
      if(err.code=='invalid-email'){
        res='The Email is badly formatted';
      }else if(err.code=='weak-password'){
        res='Password should be at least 6 character';
      }else if(err.code=='email-already-in-use'){
        res='The email address is already in use';
      }
    }catch(err){
      return err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password}) async {
    String res ='Some error occurred';

    try{

      if(email.isNotEmpty && password.isNotEmpty ){
      await  _auth.signInWithEmailAndPassword(email: email, password: password);
        res='Success';
      }else{
        res='Please enter all the field';
      }
    }on FirebaseException catch(err){
      if(err.code=='invalid-email'){
        res='The Email is badly formatted';
      }else if(err.code=='weak-password'){
        res='Password should be at least 6 character';
      }else if(err.code=='user-not-found'){
        res='No user found';
      }else if(err.code=='wrong-password'){
        res='The password is invalid';
      }
    }catch(err){
      res=err.toString();
      debugPrintThrottled(err.toString());
    }
     return res;
  }


  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // for storing self information
  static late Users me;

  User get user => _auth.currentUser!;

  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('Push Token: $t');
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });
  }





  // for sending push notification
  static Future<void> sendPushNotification(
      ChatUser chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": me.username, //our name should be send
          "body": msg,
          "android_channel_id": "chats"
        },
        // "data": {
        //   "some_data": "User ID: ${me.id}",
        // },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
            'key=AAAAUAQ0LcQ:APA91bFUjFf2Qc1jnAuJcZXSxxL0ZY-XtkOcH01Lu5JlhmEUMBmIKC6YNH9Pid4bzc_OEP_0VN4t2GIRM93HUDWtmFjjbiW3awLLn-IRMdPi3sc2y4OTvf6zneGv-UHFqHwXbVXF92Pm'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }



  Future<void> getSelfInfo()  async {
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

      me = Users.fromSnap(userSnap);
  }

  // for creating a new user
   Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        id: user.uid,
        name: user.displayName.toString(),
        email: user.email.toString(),
        about: "Hey, I'm using We Chat!",
        image: user.photoURL.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');

    return await _firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // for getting id's of known users from firestore database
  Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  // for getting all users from firestore database
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    log('\nUserIds: $userIds');

    return _firestore
        .collection('users')
        .where('uid',
        whereIn: userIds.isEmpty
            ? ['']
            : userIds) //because empty list throws an error
    // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }


  // for updating user information
  Future<void> updateUserInfo() async {
    await _firestore.collection('users').doc(user.uid).update({
      'name': me.username,
      'about': me.bio,
    });
  }

  // // update profile picture of user
  // Future<void> updateProfilePicture(File file) async {
  //   //getting image file extension
  //   final ext = file.path.split('.').last;
  //   log('Extension: $ext');
  //
  //   //storage file ref with path
  //   final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
  //
  //   //uploading image
  //   await ref
  //       .putFile(file, SettableMetadata(contentType: 'image/$ext'))
  //       .then((p0) {
  //     log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
  //   });
  //
  //   //updating image in firestore database
  //   me.image = await ref.getDownloadURL();
  //   await _firestore
  //       .collection('users')
  //       .doc(user.uid)
  //       .update({'image': me.image});
  // }

  // for getting specific user info
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return _firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }
  Future<void> updateActiveStatus(bool isOnline) async {

    await _firestore.collection('users').doc(userId).update({
      'isOnline': isOnline,
      'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
      'pushToken': me.pushToken,
    }).then((value) =>  log('Updated Token: ${me.pushToken}'));
  }

}