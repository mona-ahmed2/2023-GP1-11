import 'package:wjjhni/Chatbot/chatbot_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wjjhni/widgets/home_widget.dart';
import '../widgets_to_be_implemented/more.dart';
import '../widgets_to_be_implemented/myAdvisor.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePageStu extends StatefulWidget {
  const HomePageStu({super.key});

  @override
  State<HomePageStu> createState() => _HomePageStuState();
}

class _HomePageStuState extends State<HomePageStu> {
  int _selecetedIndex = 3;
  final List<String> _titles = const ['المزيد', 'مرشدتي', 'أسأل', 'الرئيسية'];

   List<Widget> _tabs =  [
    MoreScreen(isAdvisor: false,isStudent: true,),
    MyAdvisor(),
    ChatbotScreen() ,
    HomeWidget() //replace with home ,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 231, 231, 231),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        title: Text(_titles[_selecetedIndex]),
        centerTitle: true,
        leading: IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut(); //logout
              },
              icon: const Icon(Icons.logout))
        
      ),
      body: _tabs[_selecetedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: const Color.fromRGBO(55, 94, 152, 0.8), width: 2))),
        child: SafeArea(
          child: GNav(
            selectedIndex: 3,
            onTabChange: (newIndex) {
              setState(() {
                _selecetedIndex = newIndex;
              });
            },
            gap: 16,
            
            tabBackgroundColor: Color.fromARGB(255, 18, 164, 186)
                .withOpacity(0.1), // selected tab background color
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            activeColor: const Color.fromRGBO(55, 94, 152, 1),
            // tabBorder: Border(top: BorderSide(color: Colors.black, width: 3.0)),
            // tabBorderRadius: 2,
        
            iconSize: 24,
            backgroundColor: Color.fromRGBO(246, 247, 249, 1),
            tabs: [
              GButton(
                icon: Icons.apps,
                text: "المزيد",
                iconColor: Color.fromARGB(255, 151, 159, 171),
              ),
              GButton(
                icon: Icons.lightbulb,
                iconColor: Color.fromARGB(255, 151, 159, 171),
                text: "مرشدتي",
              ),
              GButton(
                icon: Icons.wechat,
                text: "أسأل",
                iconColor: Color.fromARGB(255, 151, 159, 171),
              ),
              // GButton(
              //   icon: Icons.calendar_month,
              //   text: "home",
              // ),
        
              GButton(
                icon: Icons.home,
                text: "الرئيسية",
                iconColor: Color.fromARGB(255, 151, 159, 171),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
