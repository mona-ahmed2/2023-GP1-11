//import packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wjjhni/Screens/splash_screen.dart';
import 'package:wjjhni/main_screen_for_navigation/homeAdvisor.dart';
import 'package:wjjhni/main_screen_for_navigation/homeStudent.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isUser = false;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    isLoading = true;
    String uid = FirebaseAuth.instance.currentUser!.uid;//retrieves the user id of the currently signed-in user.
    FirebaseFirestore.instance//query for retrieve data from the firestore collection 'academic_advisors
        .collection('academic_advisors')
        .where('uid', isEqualTo: uid)
        .get()
        .then(
            (value) {
          if (kDebugMode) {
            print(value.toString());
          }
          value.docs.isNotEmpty ? isUser = true : isUser = false;
          setState(() {
          isLoading=false;//splashscreen
          });
        });
    if (kDebugMode) {
      print(isUser.toString());//in console
    }
    super.initState();
  }

/* -----------------------------------------
      we have two different users and some of the
      content of the home screen will change based on the rule of the user
--------------------------------------------*/

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SplashScreen();
    } 
  if(isUser){
return HomePageAdvisor();
  }
  else{
return HomePageStu();

  }

  
  }
}