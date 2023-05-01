import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/globleVariable.dart';
import 'package:insta/widgets/post_card.dart';

class ProfilePost extends StatelessWidget {
  final snapshot;
  const ProfilePost({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: mobileBackgroundColor,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        backgroundColor: mobileBackgroundColor,
        leading:Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black,size: 30,),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        leadingWidth: 45,
        title: const Text('Post' ,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Color(0xFF836F71)),),
        shadowColor: mobileBackgroundColor,
        titleSpacing: 0,
        elevation: 0,
      ),
      body: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index)=> Container(
              margin:EdgeInsets.symmetric(horizontal:width > webScreenSize? width*0.3:0 ) ,
              child: PostCard(
                  snap:snapshot.data!.docs[index].data(),
              ),
            ),
      ),
    );
  }
}
