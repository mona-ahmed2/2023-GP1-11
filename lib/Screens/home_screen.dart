import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wjjhni/Screens/signup_email_password_screen.dart';
import 'package:wjjhni/Screens/splash_screen.dart';
import 'availability_hours_screen.dart';
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
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
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
          isLoading=false;
          });
        });
    if (kDebugMode) {
      print(isUser.toString());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة الرئيسية'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
      ),
      body:isLoading?const SplashScreen(): Directionality(
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
            isUser?SizedBox():Text(
              "يمكنك الوصول إلى المعلومة سريعاً\n باستخدام روبوت المحادثة المدعم بالذكاء الاصطناعي",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.15,
              ),
            ),
            Expanded(child: Container()),
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
                        builder: (context) => const AvailabilityHoursScreen()));
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'الساعات المتاحة', style:TextStyle(color:Colors.white) ,
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.more_time,color:Colors.white),
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
    );
  }
}
