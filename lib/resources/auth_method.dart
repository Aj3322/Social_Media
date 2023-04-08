import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/users.dart';
import 'package:insta/resources/storageMethod.dart';

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


}