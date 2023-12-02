import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wjjhni/Screens/profile_screen.dart';
import 'package:wjjhni/Screens/splash_screen.dart';
import 'availability_hours_screen.dart';
import 'availabilty_home_screen.dart';
import 'chatbot_screen.dart';

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
  Widget build(BuildContext context) {//main structure of the screen
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الصفحة الرئيسية'),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
          leading: IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();//logout
              },
              icon: const Icon(Icons.logout)),
        ),
        body:isLoading?const SplashScreen(): Directionality(//false : display the main content
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SvgPicture.asset(
                  'assets/chat.svg',
                  height: 340,
                  width: 400,
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                "الإرشاد الأكاديمي\n بين يديك",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.15,
                  color: Color.fromRGBO(55, 94, 152, 1),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              isUser?SizedBox():Text(//true:empty
                "يمكنك الوصول إلى المعلومة سريعاً\n باستخدام روبوت المحادثة المدعم بالذكاء الاصطناعي",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.15,
                ),
              ),
              Expanded(child: Container()),//pushing the next widgets towards the bottom of the screen
              isUser?Container():SizedBox(
                height: 65,
                width: 360,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const ChatbotScreen()),
                        );
                      });
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'أبدأ المحادثة', style:TextStyle(color:Colors.white) ,
                        ),
                        SizedBox(width: 10,),
                        Icon(Icons.chat, color:Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
              isUser?SizedBox(
                height: 65,
                width: 360,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AvailabilityHomeScreen()));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'الساعات المتاحة', style:TextStyle(color:Colors.white) ,
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.access_time_outlined,color:Colors.white),
                      ],
                    ),
                  ),
                ),
              ):Container(),
              SizedBox(
                height: 65,
                width: 360,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const EmailPasswordSignup()));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'الملف الشخصي', style:TextStyle(color:Colors.white),
                        ),
                        SizedBox(width: 10,),
                        Icon(Icons.person , color:Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
