import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta/models/users.dart';
import 'package:insta/providers/users_provider.dart';
import 'package:insta/screen/sing_up_Screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/globleVariable.dart';
import 'package:provider/provider.dart';
class mobileScreenLayout extends StatefulWidget {
  const mobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<mobileScreenLayout> createState() => _mobileScreenLayoutState();
}

class _mobileScreenLayoutState extends State<mobileScreenLayout> {

  void navigateToSignUp(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }
  int _page=0;
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();

    //  bottom bar:
     //SystemChrome.setEnabledSystemUIMode (SystemUiMode.immersive, overlays: []);
     //SystemUiOverlay.top
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page){
    _pageController.jumpToPage(page);
}

void onPageChanged(int page){
 setState(() {
   _page=page;
 });
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItem,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(topRight: Radius.circular(40),topLeft: Radius.circular(40)),
        child: SizedBox(
          height: 70,
          child: CupertinoTabBar(
            backgroundColor: const Color(0xff3E2F4C),
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home,color: _page==0? primaryColor : secondaryColor,), label: '', backgroundColor: primaryColor,),
              BottomNavigationBarItem(icon: Icon(Icons.search,color: _page==1? primaryColor : secondaryColor), label:'' , backgroundColor: primaryColor),
              BottomNavigationBarItem(icon: Icon(Icons.add_circle ,color: _page==2? primaryColor : secondaryColor), label: '', backgroundColor: primaryColor),
              BottomNavigationBarItem(icon: Icon(Icons.favorite ,color: _page==3? primaryColor : secondaryColor), label: '', backgroundColor: primaryColor),
              BottomNavigationBarItem(icon: Icon(Icons.person,color: _page==4? primaryColor : secondaryColor), label: '', backgroundColor: primaryColor),

            ],
            onTap: navigationTapped,
          ),
        ),
      ),
    );
  }
}
