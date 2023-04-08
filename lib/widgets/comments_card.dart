import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/users.dart';
import 'package:insta/providers/users_provider.dart';
import 'package:insta/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 13),
            color: textColor,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    snap.data()['profilePic'],
                  ),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: snap.data()['name'],
                                  style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black)
                              ),
                              TextSpan(
                                text: ' ${snap.data()['text']}',
                                  style: const TextStyle(color: Colors.black45)
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            DateFormat.yMMMd().format(
                              snap.data()['datePublished'].toDate(),

                            ),
                            style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400,color: Colors.cyan),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.favorite,
                    size: 16,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }
}