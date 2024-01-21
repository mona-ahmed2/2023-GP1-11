import 'package:wjjhni/Screens_to_be_implemented/all_appointments.dart';
import 'package:wjjhni/Screens_to_be_implemented/chat_screen.dart';
import 'package:wjjhni/Screens_to_be_implemented/book_appointment_screen.dart';
import 'package:wjjhni/Screens_to_be_implemented/rate_screen.dart';
import 'package:flutter/material.dart';

class MyAdvisor extends StatefulWidget {
  const MyAdvisor({super.key});

  @override
  State<MyAdvisor> createState() => _MyAdvisorState();
}

class _MyAdvisorState extends State<MyAdvisor> {
  static final List<String> titles = [
    "محادثة مرشدتي",
    "حجز موعد",
    "مواعيدي مع مرشدتي",
    "تقييم مرشدتي"
  ];

  static final List<IconData> icons = [
    Icons.chat_rounded,
    Icons.add,
    Icons.calendar_month,
    Icons.stars,
  ];
  static final List<Widget> links = [
    ChatScreen(),
    BooKAppointment(),
    AllAppointments(),
    RateScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      scrollDirection: Axis.vertical,
      itemCount: titles.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(8.0),
          height: 100,
          child: InkWell(
            onTap :  () async {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => links[index]));
            },
            child: Card(
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(titles[index],
                    style: TextStyle(fontSize: 24, color: Colors.black)),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    icons[index],
                    size: 40.0,
                    color: const Color.fromRGBO(55, 94, 152, 1),
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
