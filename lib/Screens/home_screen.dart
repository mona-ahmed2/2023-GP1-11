import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'chatbot_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SvgPicture.asset(
              'assets/chat.svg',
              height: 400,
              width: 400,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "الإرشاد الأكاديمي\n بين يديك",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.15,
              color: const Color.fromRGBO(55, 94, 152, 1),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            "يمكنك الوصول إلى المعلومة سريعاً\n باستخدام روبوت المحادثة المدعم بالذكاء الاصطناعي",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 1.15,
            ),
          ),
          Expanded(child: Container()),
          SizedBox(
            height: 65,
            width: 360,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: ElevatedButton(
                  child: Text(
                    'أبدأ المحادثة',
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
                      textStyle: TextStyle(
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
