import 'package:flutter/material.dart';
import 'package:insta/models/users.dart';
import 'package:insta/providers/users_provider.dart';
import 'package:insta/utils/colors.dart';
import 'package:provider/provider.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final Users users = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text(
          'username',
        ),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(users.photoUrl),
                  )
                ],
              ),
            ],
          ),)
        ],
      ),
    );
  }
}
