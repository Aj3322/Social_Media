import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta/screen/logIn_screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: mobileBackgroundColor,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        backgroundColor: mobileBackgroundColor,
        title: const Text('Feed' ,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Color(0xFF836F71)),),
        titleSpacing: 30,
        shadowColor: mobileBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(onPressed: () async{
            await FirebaseAuth.instance.signOut();
            Navigator.of(context)
                .pushReplacement(
                MaterialPageRoute(
                builder: (context) =>
            const LoginScreen()));
            },
              icon: const Icon(Icons.chat_rounded,color: Color(0xFF8F8785),)),

        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context , AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>>snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index)=> PostCard(
              snap:snapshot.data!.docs[index].data()
            ),

          );
        },
      ),
    );
  }
}
