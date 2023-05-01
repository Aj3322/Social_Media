import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/users.dart';
import 'package:insta/resources/auth_method.dart';
import 'package:insta/resources/chat_method.dart';
import 'package:insta/screen/chat_detail.dart';
import 'package:insta/screen/profile_screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/globleVariable.dart';
import '../models/message.dart';
import '../utils/date_formate.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}
Message? _message;
bool msg =false;
class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    Message? _message;
    bool msg =false;
    bool userIds=false;


    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chat',
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              onPressed: () {_showBottomSheetImage();},
              child: const Icon(
                Icons.add,
                size: 38,
                color: Colors.white,
              )),
        ),
        body: StreamBuilder(
          stream: AuthMethods().getMyUsersId(),
          builder: (context,  snapshot) {
            return StreamBuilder(
              stream: AuthMethods().getAllUsers(snapshot.data?.docs.map((e) => e.id).toList()??[]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    ChatUser user = ChatUser(
                        image: (snapshot.data! as dynamic).docs[index]
                        ['photoUrl'],
                        about: (snapshot.data! as dynamic).docs[index]['bio'],
                        name: (snapshot.data! as dynamic).docs[index]
                        ['username'],
                        createdAt: '',
                        isOnline: (snapshot.data! as dynamic).docs[index]
                        ['isOnline'],
                        id: (snapshot.data! as dynamic).docs[index]['uid'],
                        lastActive: (snapshot.data! as dynamic).docs[index]
                        ['lastActive'],
                        email: (snapshot.data! as dynamic).docs[index]['email'],
                        pushToken: (snapshot.data! as dynamic).docs[index]['pushToken']??'');


                      return  (snapshot.data! as dynamic).docs[index]['uid']==userId?const Divider(height: 0,):InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatScreenDetail(
                                user: user,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            ListTile(
                              leading: Container(

                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red,
                                      Colors.yellow,
                                      Colors.orange,
                                      Colors.redAccent
                                    ],
                                  ),),
                                child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(12)),
                                  child: SizedBox(
                                    width:45 ,
                                    height: 45,
                                    child: Image.network( (snapshot.data! as dynamic).docs[index]['photoUrl'],fit: BoxFit.cover,),

                                  ),
                                ),
                              ),
                              title: Text(
                                (snapshot.data! as dynamic).docs[index]['username'],
                                style: const TextStyle(color: headerColor,fontWeight: FontWeight.bold),
                              ),
                              subtitle: StreamBuilder(
                                  stream: ChatMethod.getLastMessage(user),
                                  builder: (context, snapshot) {
                                    final data = snapshot.data?.docs;
                                    final list = data
                                        ?.map((e) => Message.fromJson(e.data()))
                                        .toList() ??
                                        [];
                                    if (list.isNotEmpty) {_message = list[0];
                                    if(_message!.read.isEmpty){
                                      msg= true;
                                    }
                                    }else{_message=null;}



                                    return  Text(
                                        _message != null
                                            ? _message!.type == Type.image
                                            ? 'image'
                                            : _message!.msg
                                            :'Last Massage',style: const TextStyle(color: primaryColor,fontSize: 16),
                                        maxLines: 1);
                                  }),
                              trailing:  Text(
                                  (snapshot.data! as dynamic).docs[index]['isOnline']
                                      ? 'Online'
                                      : MyDateUtil.getLastActiveTime(
                                      context: context,
                                      lastActive:  (snapshot.data! as dynamic).docs[index]['lastActive']),
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.black54)),
                            ),
                            Container(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: const Divider(
                                  height: 4,
                                  color: textColor,
                                ))
                          ],
                        ),
                      );


                  },
                );
              },
            );
          },

        )

    );
  }
  void _showBottomSheetImage() {
    var mq = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        backgroundColor: mobileBackgroundColor,
        builder: (_) {
          return _bodyDialog();
        });}


  Widget _bodyDialog(){
   return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: (snapshot.data! as dynamic).docs.length,
          itemBuilder: (context, index) {
            ChatUser user = ChatUser(
                image: (snapshot.data! as dynamic).docs[index]
                ['photoUrl'],
                about: (snapshot.data! as dynamic).docs[index]['bio'],
                name: (snapshot.data! as dynamic).docs[index]
                ['username'],
                createdAt: '',
                isOnline: (snapshot.data! as dynamic).docs[index]
                ['isOnline'],
                id: (snapshot.data! as dynamic).docs[index]['uid'],
                lastActive: (snapshot.data! as dynamic).docs[index]
                ['lastActive'],
                email: (snapshot.data! as dynamic).docs[index]['email'],
                pushToken: '');
            return  (snapshot.data! as dynamic).docs[index]['uid']==userId?Text(''):InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(uid: (snapshot.data! as dynamic).docs[index]['uid'])
                  ),
                );
              },
              child: Column(
                children: [
                  ListTile(
                    leading: Container(

                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        gradient: LinearGradient(
                          colors: [
                            Colors.red,
                            Colors.yellow,
                            Colors.orange,
                            Colors.redAccent
                          ],
                        ),),
                      child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(12)),
                        child: SizedBox(
                          width:40 ,
                          height: 40,
                          child: Image.network( (snapshot.data! as dynamic).docs[index]['photoUrl'],fit: BoxFit.cover,),

                        ),
                      ),
                    ),
                    title: Text(
                      (snapshot.data! as dynamic).docs[index]['username'],
                      style: const TextStyle(color: headerColor,fontWeight: FontWeight.bold),
                    ),
                    subtitle:Text((snapshot.data! as dynamic).docs[index]['bio'],
                        style: const TextStyle(color: primaryColor,fontWeight: FontWeight.w400)),
                    trailing:IconButton(onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatScreenDetail(
                            user: user,
                          ),
                        ),
                      );
                    }, icon: const Icon(Icons.message_rounded,color: headerColor,),),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: const Divider(
                        height: 4,
                        color: textColor,
                      ))
                ],
              ),
            );
          },
        );
      },
    );
  }
}
