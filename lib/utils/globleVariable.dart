import 'package:flutter/material.dart';
import 'package:insta/screen/add_post.dart';
import 'package:insta/screen/feed_screen.dart';
import 'package:insta/screen/profile_screen.dart';
import 'package:insta/screen/search_screen.dart';

const webScreenSize=600;

const homeScreenItem = [
      FeedScreen(),
      SearchScreen(),
      AddPostScreen(),
      Text("Notfication"),
      ProfileScreen(),
    ];