import 'dart:developer';
import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/models/message.dart';
import 'package:insta/models/users.dart';
import 'package:insta/resources/chat_method.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/widgets/message_card.dart';
import 'package:provider/provider.dart';

import '../providers/users_provider.dart';
class ChatScreenDetail extends StatefulWidget {
  final ChatUser user;
  const ChatScreenDetail({super.key, required this.user});

  @override
  State<ChatScreenDetail> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenDetail> {

  List<Message> _list = [];
  String? _image;

  final _textController = TextEditingController();

  //showEmoji -- for storing value of showing or hiding emoji
  //isUploading -- for checking if image is uploading or not?
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          //if emojis are shown & back button is pressed then hide emojis
          //or else simple close current screen on back button click
          onWillPop: () {
            if (_showEmoji) {
              setState(() => _showEmoji = !_showEmoji);
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: mobileBackgroundColor,
              title: Text(
                widget.user.name,
                style: const TextStyle(
                  color: headerColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: headerColor,
                    size: 35,
                  ),
                  onPressed: () => Navigator.of(context).pop()),
              leadingWidth: 20,
            ),

            backgroundColor:mobileBackgroundColor,

            //body
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: ChatMethod.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                      //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                      //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                              ?.map((e) => Message.fromJson(e.data()))
                              .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                                itemCount: _list.length,
                                padding: EdgeInsets.only(top: mq.height * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(message: _list[index],photoUrl: widget.user.image,);
                                });
                          } else {
                            return const Center(
                              child: Text('Say Hii! 👋',
                                  style: TextStyle(fontSize: 20,color: primaryColor)),
                            );
                          }
                      }
                    },
                  ),
                ),

                //progress indicator for showing uploading
                if (_isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: CircularProgressIndicator(strokeWidth: 2))),

                //chat input filed
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Row(
                    children: [
                      //input field & buttons
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          color: textColor,
                          child: Row(
                            children: [
                              //emoji button
                              IconButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    setState(() => _showEmoji = !_showEmoji);
                                  },
                                  icon: const Icon(Icons.emoji_emotions,
                                      color: primaryColor, size: 25)),

                              Expanded(
                                  child: TextField(
                                    controller: _textController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    onTap: () {},
                                    decoration: const InputDecoration(
                                        hintText: 'Type Something...',
                                        hintStyle: TextStyle(color: primaryColor),
                                        border: InputBorder.none),
                                  )),

                              //pick image from gallery button
                              IconButton(
                                  onPressed: () {_showBottomSheetImage();},
                                  icon: const Icon(Icons.image,
                                      color: headerColor, size: 26)),

                              //take image from camera button
                              IconButton(
                                  onPressed: () {
                                    if (_textController.text.isNotEmpty) {
                                      if (_list.isEmpty) {
                                        //on first message (add user to my_user collection of chat user)
                                        ChatMethod.sendFirstMessage(
                                            widget.user, _textController.text, Type.text);
                                      } else {
                                        //simply send message
                                        ChatMethod.sendMessage(
                                            widget.user, _textController.text, Type.text);
                                      }
                                      _textController.text = '';
                                    }
                                    _textController.text = '';
                                  },
                                  icon: const Icon(Icons.send,
                                      color: headerColor, size: 26)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // //show emojis on keyboard emoji button click & vice versa
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * .35,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(
                        bgColor: const Color.fromARGB(255, 234, 248, 255),
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
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
          return ListView(
            shrinkWrap: true,
            padding:
            EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              //pick profile picture label
              const Text('Pick A Image ',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: primaryColor,fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              SizedBox(height: mq.height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 70);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() => _isUploading = true);
                          Navigator.pop(context);
                          await ChatMethod.sendChatImage(
                              widget.user, File(image.path));
                          setState(() => _isUploading = false);
                          // for hiding bottom sheet

                        }
                      },
                      child: Image.asset('assets/image/img_1.png')),

                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() => _isUploading = true);
                          Navigator.pop(context);
                          await ChatMethod.sendChatImage(
                              widget.user, File(image.path));
                          setState(() => _isUploading = false);

                        }
                      },
                      child: Image.asset('assets/image/img.png')),
                ],
              )
            ],
          );
        });}
}