import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/resources/auth_method.dart';
import 'package:insta/responsive/mobileScreenLayout.dart';
import 'package:insta/responsive/responsive_layout_screen.dart';
import 'package:insta/responsive/webScreenLayout.dart';
import 'package:insta/screen/logIn_screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/utils.dart';
import 'package:insta/widgets/input_text_field.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailControler=TextEditingController();
  final TextEditingController _passControler=TextEditingController();
  final TextEditingController _biolControler=TextEditingController();
  final TextEditingController _userNameControler=TextEditingController();
  Uint8List? _image;
  bool isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailControler.dispose();
    _passControler.dispose();
    _biolControler.dispose();
    _userNameControler.dispose();
  }

  void signupUser () async {
    setState(() {
      isLoading=true;
    });
   String res = await AuthMethods().signUpUser(
      email: _emailControler.text,
      password: _passControler.text,
      username: _userNameControler.text,
      bio: _biolControler.text,
      file: _image!,
    );
   if(res=='success'){
     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const ResponsiveLayout(webScreenLayout: webScreenLayout(), mobileScreenLayout: mobileScreenLayout())));
   }
    debugPrintThrottled(res);
     showSnakBar(res,context);
   setState(() {
     isLoading=false;
   });
  }


  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }


    void selectImage() async {
   Uint8List im = await pickImage(ImageSource.gallery);
   setState(() {
     _image = im ;
   });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(),flex: 2,),
              Image.asset('assets/image/logo.png',
                //color: primaryColor,
                height: 64,),
              const SizedBox(height: 64,),
              Stack(
                children:  [
                  _image!=null?CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  )
                  :  const CircleAvatar(
                    radius: 64,
                    backgroundImage: AssetImage('assets/image/logo.png'),
                    backgroundColor: primaryColor,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(onPressed: selectImage, icon: Icon(Icons.add_a_photo,),),),
                ],
              ),
              const SizedBox(height: 24,),
              TextFieldInput(
                //txt field input for email
                textInputType: TextInputType.text ,
                hinText: "Username",
                textEditingController: _userNameControler , ),
              const SizedBox(height: 24,),
              TextFieldInput(
                //txt field input for email
                textInputType: TextInputType.emailAddress ,
                hinText: "Enter Your Email",
                textEditingController: _emailControler , ),
              const SizedBox(height: 24,),
              // txt field input for password
              TextFieldInput(
                textInputType: TextInputType.visiblePassword ,
                hinText: "Enter Your Password",
                textEditingController: _passControler ,
                isPass: true,),
              const SizedBox(height: 24,),
              TextFieldInput(
                //txt field input for email
                textInputType: TextInputType.text ,
                hinText: "Enter Your Bio",
                textEditingController: _biolControler , ),
              //button log in
              const SizedBox(height: 24,),
              InkWell(
                onTap:signupUser,

                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))
                    ),
                    color: blueColor,
                  ),
                  child: isLoading? const Center(child: CircularProgressIndicator(color: Colors.white,),) : const Text("Sign Up"),

                ),
              ),
              const SizedBox(height: 12,),
              Flexible(child: Container(),flex: 2,),
              //transfering to sing up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Already have an account? " ,style: TextStyle(color: Colors.black),),

                  ),
                  GestureDetector(
                    onTap: navigateToLogin,

                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Log in" , style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),

                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ) ,
    );
  }
}

