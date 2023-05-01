import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta/models/message.dart';
import 'package:insta/resources/chat_method.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/date_formate.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message, required this.photoUrl});

  final Message message;
  final String photoUrl;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {

  @override
  Widget build(BuildContext context) {
    bool isMe = ChatMethod.user.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: isMe ? _sendMessage() : _receiveMessage());
  }

  // sender or another user message
  Widget _receiveMessage() {
    var mq = MediaQuery.of(context).size;
    //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      ChatMethod.updateMessageReadStatus(widget.message);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.photoUrl),
            radius: 20,
          ),
          Row(
            children: [
              //message content
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: mq.width*0.7,
                    minWidth: mq.width*0.15,
                      maxHeight: mq.height*.4
                  ),
                  padding: EdgeInsets.all(widget.message.type == Type.image
                      ? mq.width * .009
                      : mq.width * .04),
                  margin: EdgeInsets.symmetric(
                      horizontal: mq.width * .12,),
                  decoration: const BoxDecoration(
                      color: textColor,
                      //making borders curved
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: widget.message.type == Type.text
                      ?
                  //show text
                  Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                      :
                  //show image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(widget.message.msg
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: mq.width * .15,top: 4),
            child: Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  // our or user message
  Widget _sendMessage() {
    var mq = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                constraints:  BoxConstraints(
                  maxWidth: mq.width*0.7,
                    minWidth: mq.width*0.15,
                  maxHeight: mq.height*.4
                ),
                padding: EdgeInsets.all(widget.message.type == Type.image
                    ? mq.width * .009
                    : mq.width * .04),
                margin: EdgeInsets.symmetric(
                    horizontal: mq.width * .04, vertical: mq.height * .01),
                decoration: const BoxDecoration(
                    color:primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(20),)),
                child: widget.message.type == Type.text ?
                Text(
                  widget.message.msg,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                )
                    :
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(widget.message.msg
                  ),
                ),
              ),
            ),

          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //for adding some space


            //double tick blue icon for message read
            if (widget.message.read.isNotEmpty)
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 15),

            //for adding some space
            const SizedBox(width: 2),

            //sent time
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            SizedBox(width: mq.width * .07),
          ],
        ),
      ],
    );
  }

  // bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    var mq = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return Container(
            color: mobileBackgroundColor,
            child: ListView(
              shrinkWrap: true,
              children: [
                //black divider
                Container(
                  height: 4,
                  margin: EdgeInsets.symmetric(
                      vertical: mq.height * .015, horizontal: mq.width * .4),
                  decoration: BoxDecoration(
                      color: Colors.grey, borderRadius: BorderRadius.circular(8)),
                ),

                widget.message.type == Type.text
                    ?
                //copy option
                _OptionItem(
                    icon: const Icon(Icons.copy_all_rounded,
                        color: Colors.blue, size: 26),
                    name: 'Copy Text',
                    onTap: () async {
                      await Clipboard.setData(
                          ClipboardData(text: widget.message.msg))
                          .then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);


                      });
                    })
                    :
                //save option
                Container(),

                //separator or divider
                if (isMe)
                  Divider(
                    color: Colors.black54,
                    endIndent: mq.width * .04,
                    indent: mq.width * .04,
                  ),

                // //edit option
                // if (widget.message.type == Type.text && isMe)
                //   _OptionItem(
                //       icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                //       name: 'Edit Message',
                //       onTap: () {
                //         //for hiding bottom sheet
                //         Navigator.pop(context);
                //
                //       }),

                //delete option
                if (isMe)
                  _OptionItem(
                      icon: const Icon(Icons.delete_forever,
                          color: Colors.red, size: 26),
                      name: 'Delete Message',
                      onTap: () async {
                        await ChatMethod.deleteMessage(widget.message).then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);
                        });
                      }),

                //separator or divider
                Divider(
                  color: Colors.black54,
                  endIndent: mq.width * .04,
                  indent: mq.width * .04,
                ),

                //sent time
                _OptionItem(
                    icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                    name:
                    'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                    onTap: () {}),

                //read time
                _OptionItem(
                    icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                    name: widget.message.read.isEmpty
                        ? 'Read At: Not seen yet'
                        : 'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                    onTap: () {}),
              ],
            ),
          );
        });
  }

  //dialog for updating message content

}

//custom options card (for copy, edit, delete, etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(
              left: mq.width * .05,
              top: mq.height * .015,
              bottom: mq.height * .015),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        letterSpacing: 0.5)))
          ]),
        ));
  }
}