import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/models/users.dart';
import 'package:insta/providers/users_provider.dart';
import 'package:insta/resources/firestore_method.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
Uint8List? _file;
bool isLoading=false;

final TextEditingController _discriptionControler = TextEditingController();


  _selectImage(BuildContext context) async {
    return showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: Text('Create a post'),
        children: [
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: Text('Take a Photo'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.camera);
              setState(() {
                _file=file;
              });
            },
          ),

          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: const Text('Choose from gallery'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.gallery);
              setState(() {
                _file=file;
              });
            },
          ),

          SimpleDialogOption(

            padding: EdgeInsets.all(20),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

  void postImage(
      String username,
      String uid,
      String profileImage,
      ) async {
    setState(() {
      isLoading=true;
    });
    try {
      String res = await FirestoreMethods().UploadPost(
          uid, _discriptionControler.text, _file!, username, profileImage);

      if (res == 'Success') {
        setState(() {
          isLoading=false;
        });
        showSnakBar("posted", context);
        clearImage();
      }else{
        setState(() {
          isLoading=false;
        });
        showSnakBar(res, context);
      }
    }catch(err){
      setState(() {
        isLoading=false;
      });
      showSnakBar(err.toString(), context);
     }
  }

  void clearImage(){
    setState(() {
      _file=null;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _discriptionControler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Users users = Provider.of<UserProvider>(context).getUser;
    return _file==null? Center(
      child: IconButton(
        onPressed: () => _selectImage(context) ,
        icon: const Icon(Icons.upload , size: 54,color: textColor,),
      ),
    ): Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          onPressed: clearImage,
          icon: const Icon(Icons.arrow_back_sharp,color: Colors.black,),
        ),
        title: const Text('Post to',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Color(0xFF836F71),),),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => postImage(users.username, users.uid, users.photoUrl),
            child: const Text('Post', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold,fontSize: 16,),),
          ),
        ],
      ),
    body: Column(
      children: [
        isLoading? const  LinearProgressIndicator(): const Padding(padding: EdgeInsets.only(top: 0),),const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  users.photoUrl
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.4,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: _discriptionControler,
                decoration: const InputDecoration(
                  hintText: 'Write a caption',
                  border: InputBorder.none,
                ),
                maxLines: 8,
              ),
            ),
            SizedBox(
              height: 45,
              width: 45,
              child: AspectRatio(
                aspectRatio: 481/451,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image:MemoryImage(_file!),
                      fit: BoxFit.fill,
                      alignment: FractionalOffset.topCenter,
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
          ],
        )
      ],
    ),

    );
  }
}
