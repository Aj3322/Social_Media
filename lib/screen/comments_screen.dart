import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/users.dart';
import 'package:insta/providers/users_provider.dart';
import 'package:insta/resources/firestore_method.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/utils.dart';
import 'package:insta/widgets/comments_card.dart';
import 'package:provider/provider.dart';
class CommentsScreen extends StatefulWidget {
  final postId;
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController =
  TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FirestoreMethods().postComment(
        widget.postId,
        commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        showSnakBar( res,context,);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showSnakBar(
        err.toString(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Users user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios,color: headerColor,),onPressed: () => Navigator.of(context).pop(),),
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments' ,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Color(0xFF836F71)),),
        titleSpacing: 30,
        shadowColor: mobileBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.chat_rounded,color: Color(0xFF8F8785),)),

        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentCard(
              snap: snapshot.data!.docs[index],
            ),
          );
        },
      ),
      // text input
      bottomNavigationBar:SafeArea(
      child: Container(
      height: kToolbarHeight,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      padding: const EdgeInsets.only(left: 16,right: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(user.photoUrl),
          ),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      fillColor: Color(0xFFC9C9C9),
                      hintText: 'Comments',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            color: Color(0xFFC9C9C9),
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            color: Color(0xFFC9C9C9),
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            color: Color(0xFFC9C9C9),
                          )),
                      filled: true,
                      contentPadding:
                      const EdgeInsets.all(8).copyWith(left: 20),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: IconButton(
                      onPressed: ()=> postComment(
                                  user.uid,
                                   user.username,
                                   user.photoUrl,
                                ),
                      icon: const Icon(Icons.send,color: Colors.white,size: 30,),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    )

      // SafeArea(
      //   child: Container(
      //     height: kToolbarHeight,
      //     margin:
      //     EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      //     padding: const EdgeInsets.only(left: 16, right: 8),
      //     child: Row(
      //       children: [
      //         CircleAvatar(
      //           backgroundImage: NetworkImage(user.photoUrl),
      //           radius: 18,
      //         ),
      //         Expanded(
      //           child: Padding(
      //             padding: const EdgeInsets.only(left: 16, right: 8),
      //             child: TextField(
      //               controller: commentEditingController,
      //               decoration: InputDecoration(
      //                 hintText: 'Comment as ${user.username}',
      //                 border: InputBorder.none,
      //               ),
      //             ),
      //           ),
      //         ),
      //         InkWell(
      //           onTap: () => postComment(
      //             user.uid,
      //             user.username,
      //             user.photoUrl,
      //           ),
      //           child: Container(
      //             padding:
      //             const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      //             child: const Text(
      //               'Post',
      //               style: TextStyle(color: Colors.blue),
      //             ),
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
      ),
    );
  }
}