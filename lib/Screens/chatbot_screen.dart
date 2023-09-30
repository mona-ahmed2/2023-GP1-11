import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:math' as math;

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

// to get the current date
String getDate() {
  initializeDateFormatting();
  var now = new DateTime.now();
  var formatter = DateFormat.yMMMd("ar_SA");
  String formatted = formatter.format(now);
  return formatted;
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final messageControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(55, 94, 152, 1),
        title: Text("روبوت المحادثة"),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 16.0, bottom: 10.0),
                child: Text(
                  getDate(),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                  reverse: true,
                  itemCount: 0,
                  itemBuilder: (context, index) {}),
            ),
            Divider(
              height: 3,
              color: Colors.black,
            ),
            Container(
              color: Color.fromRGBO(129, 154, 190, 1),
              child: ListTile(
                title: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Color.fromRGBO(255, 254, 254, 1),
                  ),
                  padding: EdgeInsets.only(right: 16.0),
                  child: TextFormField(
                    controller: messageControler,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: "أدخل رسالتك",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: Transform.rotate(
                    angle: 180 * math.pi / 180,
                    child: Icon(
                      Icons.send,
                      size: 32,
                      color: Colors.black38,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
