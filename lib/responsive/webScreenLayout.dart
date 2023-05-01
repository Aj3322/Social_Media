import 'package:flutter/material.dart';
import 'package:insta/screen/sing_up_Screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/globleVariable.dart';
class webScreenLayout extends StatefulWidget {
  const webScreenLayout({Key? key}) : super(key: key);

  @override
  State<webScreenLayout> createState() => _webScreenLayoutState();
}

class _webScreenLayoutState extends State<webScreenLayout> {

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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page){
    setState(() {
      _page=page;
    });
    _pageController.jumpToPage(page);
  }

  void onPageChanged(int page){
    setState(() {
      _page=page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar : AppBar(
          backgroundColor: mobileBackgroundColor,
          title: const Text('Feed' ,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Color(0xFF836F71)),),
          titleSpacing: 30,
          shadowColor: mobileBackgroundColor,
          elevation: 0,
          actions: [
            IconButton(onPressed: ()=>navigationTapped(0),
                icon: Icon(Icons.home,color: _page==0? primaryColor : secondaryColor,)),
            IconButton(onPressed: ()=>navigationTapped(1),
                icon:Icon(Icons.search,color: _page==1? primaryColor : secondaryColor,)),
            IconButton(onPressed: ()=>navigationTapped(2),
                icon:Icon(Icons.add_photo_alternate_outlined,color: _page==2? primaryColor : secondaryColor,)),
            IconButton(onPressed: ()=>navigationTapped(3),
                icon:Icon(Icons.chat_rounded,color: _page==3? primaryColor : secondaryColor,)),
            IconButton(onPressed: ()=>navigationTapped(4),
                icon:Icon(Icons.person,color:  _page==4? primaryColor : secondaryColor,)),

          ],
        ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItem,
      ),
    );
  }
}
