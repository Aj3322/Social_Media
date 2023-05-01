
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta/resources/auth_method.dart';
import 'package:insta/screen/sing_up_Screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/globleVariable.dart';
class mobileScreenLayout extends StatefulWidget {
  const mobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<mobileScreenLayout> createState() => _mobileScreenLayoutState();
}

class _mobileScreenLayoutState extends State<mobileScreenLayout>with WidgetsBindingObserver  {

  void navigateToSignUp(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }
  int _page=0;
  late PageController _pageController;
  bool isProfile=false;

  String? changes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
    AuthMethods().getSelfInfo();
    AuthMethods.getFirebaseMessagingToken();
    WidgetsBinding.instance!.addObserver(this);
    AuthMethods().updateActiveStatus(true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed){
      AuthMethods().updateActiveStatus(true);
    }else{
      AuthMethods().updateActiveStatus(false);
    }
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
 profile();
}
profile(){
    if(_page==4){
     setState(() {
       isProfile=true;
     });
    }else{
      setState(() {
        isProfile=false;
      });
    }
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
      bottomNavigationBar:isProfile?null: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          child: SizedBox(
            height: 60,
            child: CupertinoTabBar(
              backgroundColor: const Color(0xff3E2F4C),
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home,color: _page==0? primaryColor : secondaryColor,), label: '', backgroundColor: primaryColor,),
                BottomNavigationBarItem(icon: Icon(Icons.search,color: _page==1? primaryColor : secondaryColor), label:'' , backgroundColor: primaryColor),
                BottomNavigationBarItem(icon: Icon(Icons.favorite ,color: _page==2? primaryColor : secondaryColor), label: '', backgroundColor: primaryColor),
                BottomNavigationBarItem(icon: Icon(Icons.person,color: _page==5? primaryColor : secondaryColor), label: '', backgroundColor: primaryColor,),
              ],
              onTap: navigationTapped,
            ),
          ),
        ),
      ),
    );
  }
}

