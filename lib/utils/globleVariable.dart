import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/screen/My_profile.dart';
import 'package:insta/screen/Notfication.dart';
import 'package:insta/screen/add_post.dart';
import 'package:insta/screen/chat_screen.dart';
import 'package:insta/screen/feed_screen.dart';
import 'package:insta/screen/profile_screen.dart';
import 'package:insta/screen/search_screen.dart';

const webScreenSize=600;
  var userId=FirebaseAuth.instance.currentUser!.uid;


 List<Widget> homeScreenItem = [
      const FeedScreen(),
      const SearchScreen(),
      const NotficationScreen(),
      const MyProfile(),
      const ChatScreen()
    ];