import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/users.dart';
import 'package:insta/providers/users_provider.dart';
import 'package:insta/resources/firestore_method.dart';
import 'package:insta/screen/comments_screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/utils.dart';
import 'package:insta/widgets/like%20animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating=false;


  deletePost(String postId) async {
    try {
      await FirestoreMethods().deletePost(postId);
    } catch (err) {
      showSnakBar(
        err.toString(),
        context,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final Users users = Provider.of<UserProvider>(context).getUser;

    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Container(
                          height: 5,
                        ),
                        Text(
                          DateFormat.yMMMd()
                              .format(widget.snap['datePublished'].toDate()),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            color: Color(0xFFB0A8A6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.snap['uid'].toString() == users.uid?
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              child: ListView(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: ['Delete']
                                    .map(
                                      (e) => InkWell(
                                        onTap: () {deletePost(
                                          widget.snap['postId']
                                              .toString(),
                                        );
                                        // remove the dialog box
                                        Navigator.of(context).pop();},
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ));
                  },
                  icon: const Icon(
                    Icons.more_horiz_outlined,
                    color: Color(0xFFD4BEC1),
                  ),
                )
                :Container(),
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GestureDetector(
                      onDoubleTap: ()async{
                        await FirestoreMethods().likePost(widget.snap['postId'], users.uid, widget.snap['likes']);
                        setState(() {
                          isLikeAnimating = true;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).devicePixelRatio * 140,
                            child: Image.network(
                              widget.snap['postUrl'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: isLikeAnimating? 1:0 ,

                            child: LikeAnimation(
                              isAnimating: isLikeAnimating,
                              duration: const Duration(milliseconds: 200),
                              onEnd: (){
                                setState(() {
                                  isLikeAnimating=false;
                                });
                              },
                              child: const Icon(Icons.favorite,color: Colors.red,size: 120,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 60,
                      top: 4,
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            size: 12,
                            color: Colors.red,
                          ),
                          Text(
                            '@${widget.snap['username']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: 12,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 40,
                    ),
                    child: Row(
                      children: [
                        LikeAnimation(
                            isAnimating: widget.snap['likes'].contains(users.uid),
                            smallLike: true,
                            child: IconButton(
                              onPressed: () async{
                                await FirestoreMethods().likePost(widget.snap['postId'], users.uid, widget.snap['likes']);
                              },
                              icon:widget.snap['likes'].contains(users.uid)?
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ):const Icon(
                                Icons.favorite_outline_rounded,
                                color: textColor,
                              ),
                            ),
                        ),
                        Text('${widget.snap['likes'].length}',style: const TextStyle(color: Colors.black),),
                        Container(
                          width: 30,
                        ),
                        IconButton(
                          onPressed: () =>Navigator.of(context).push(MaterialPageRoute(
                            builder: (context)=> CommentsScreen(postId:  widget.snap['postId'].toString(),),
                          ),
                          ),
                          icon: const Icon(
                            Icons.comment_outlined,
                            color: textColor,
                          ),
                        ),

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 10),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
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

                  // Container(
                  //   padding: const EdgeInsets.symmetric(vertical:12 ,horizontal:16 ),
                  // child: Column(
                  //   mainAxisSize: MainAxisSize.min,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     DefaultTextStyle(style: Theme.of(context).textTheme.subtitle2!.copyWith(fontWeight: FontWeight.w800), child: const Text('1024 likes'),),
                  //     Container(
                  //       width: double.infinity,
                  //       padding: const EdgeInsets.only(top: 4),
                  //       child: RichText(
                  //         text: const TextSpan(
                  //           style: TextStyle(color: primaryColor),
                  //           children: [
                  //             TextSpan(
                  //               style: TextStyle(fontWeight: FontWeight.bold,),
                  //               text: 'username'
                  //             ),
                  //             TextSpan(
                  //                 text: 'Hey some description to be replaced'
                  //             ),
                  //           ]
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),

                  // ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
