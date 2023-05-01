import 'package:flutter/material.dart';
import 'package:insta/utils/colors.dart';
import 'package:provider/provider.dart';

import '../models/users.dart';
import '../providers/users_provider.dart';
class NotficationCard extends StatelessWidget {
  const NotficationCard({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Users user = Provider.of<UserProvider>(context).getUser;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 13),
          color: textColor,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.uid),
                radius: 15,
              ),
              Text('    ${user.username} likes your post',style: const TextStyle(color: Colors.black),),
            ],
          ),
        ),
      ),
    );
  }
}