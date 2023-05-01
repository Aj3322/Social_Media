import 'package:flutter/material.dart';
import 'package:insta/widgets/Notfication_card.dart';

import '../utils/colors.dart';

class NotficationScreen extends StatefulWidget {
  const NotficationScreen({Key? key}) : super(key: key);

  @override
  State<NotficationScreen> createState() => _NotficationScreenState();
}

class _NotficationScreenState extends State<NotficationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text(
          'Notification',
          style: TextStyle(color: headerColor),
        ),
        elevation: 0,
        backgroundColor: mobileBackgroundColor,
        leadingWidth: 20,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: headerColor,
              size: 35,
            ),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(vertical:10 ).copyWith(left: 60),
            child: const Text('Day and Date',style: TextStyle(color: headerColor,fontSize: 16),),
          ),
          NotficationCard(),

           Padding(
             padding: const EdgeInsets.symmetric(vertical:10 ).copyWith(left: 60),
             child: const Text('Day and Date',style: TextStyle(color: headerColor,fontSize: 16),),
           ),
          NotficationCard(),
        ],
      ),
    );
  }
}
