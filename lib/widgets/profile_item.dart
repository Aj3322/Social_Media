import 'package:flutter/material.dart';

class ProfileItem extends StatefulWidget {
  final snap;
  const ProfileItem({Key? key,required this.snap}) : super(key: key);

  @override
  State<ProfileItem> createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 100,
      child: Image(
        image: NetworkImage(widget.snap['postUrl']),
      ),
    );
  }
}
