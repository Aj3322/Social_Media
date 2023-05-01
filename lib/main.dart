import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:insta/providers/users_provider.dart';
import 'package:insta/responsive/mobileScreenLayout.dart';
import 'package:insta/responsive/responsive_layout_screen.dart';
import 'package:insta/responsive/webScreenLayout.dart';
import 'package:insta/screen/logIn_screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBZi3G7eqdptSWmuMTjVZdUrkOLzXa4Ji8",
          authDomain: "instagram-c-b919f.firebaseapp.com",
          projectId: "instagram-c-b919f",
          storageBucket: "instagram-c-b919f.appspot.com",
          messagingSenderId: "343667912132",
          appId: "1:343667912132:web:8b8c9206a2d595406f0891",
          measurementId: "G-00351N86J5"
      ),
    );
  }else{
    await Firebase.initializeApp();
  }
  _channel();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> UserProvider(),),
      ],
      child: MaterialApp(
        title: 'Instagram clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        // home: LoginScreen(),
        home: StreamBuilder(
          stream:FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.connectionState==ConnectionState.active){
              if(snapshot.hasData){
                return const ResponsiveLayout(mobileScreenLayout: mobileScreenLayout(),webScreenLayout: webScreenLayout(),);
              }else if(snapshot.hasError){
                return Center(child: Text('${snapshot.error}'),);

              }
            }else if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(color: primaryColor,),);
            }
            return const LoginScreen();

          },
        ),
      ),
    );
  }
}

_channel()async{
  var result = await FlutterNotificationChannel.registerNotificationChannel(
      description: 'For Showing Message Notification',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Chats');
  log('\nNotification Channel Result: $result');
}

