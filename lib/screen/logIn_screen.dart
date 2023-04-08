
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta/resources/auth_method.dart';
import 'package:insta/responsive/mobileScreenLayout.dart';
import 'package:insta/responsive/responsive_layout_screen.dart';
import 'package:insta/responsive/webScreenLayout.dart';
import 'package:insta/screen/sing_up_Screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/utils.dart';
import 'package:insta/widgets/input_text_field.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailControler=TextEditingController();
  final TextEditingController _passControler=TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailControler.dispose();
    _passControler.dispose();

  }

  void loginUser() async {
    setState(() {
      isLoading=true;
    });
    String res = await AuthMethods().loginUser(
      email: _emailControler.text,
      password: _passControler.text,
    );

    if(res=='Success'){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const ResponsiveLayout(webScreenLayout: webScreenLayout(), mobileScreenLayout: mobileScreenLayout())));
    }

    debugPrintThrottled(res);
    showSnakBar(res,context);
    setState(() {
      isLoading=false;
    });
  }

void navigateToSignUp(){
 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignUpScreen()));
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
              Image.asset('assets/image/logo.png', height: 74,),
              const SizedBox(height: 64,),
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
              //button log in
              const SizedBox(height: 24,),
              InkWell(
                onTap: loginUser,
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
                  child: isLoading? const Center(child: CircularProgressIndicator(color: primaryColor,),) : const Text("Log in"),

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
                    child: const Text("Don't have an account?",style: TextStyle(color: Colors.black),),

                  ),
                  GestureDetector(
                    onTap: navigateToSignUp,

                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Sing up" , style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),

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
