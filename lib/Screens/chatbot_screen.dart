// import 'dart:js_interop';

import 'package:bubble/bubble.dart';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:math' as math;
import 'package:wjjhni/components/message.dart';
import 'package:wjjhni/components/chatbot_service.dart';
// import 'package:chat_bubbles/chat_bubbles.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

/* -----------------------------------------

      this method to get current date @ibtihalx
--------------------------------------------*/
String getDate() {
  initializeDateFormatting();
  var now = new DateTime.now();
  var formatter = DateFormat.yMMMd("ar_SA");
  String formatted = formatter.format(now);
  return formatted;
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final messageControler = TextEditingController();
  ChatbotService chat = ChatbotService();

  ScrollController scrollController = ScrollController();
  List<Message> msgs = [];
  bool isTyping = false;

/* -------------------------------------------------------------

this method for sending question and receiving chatbot answer @ibtihalx
-----------------------------------------------------------------*/
  void response(query) async {
    chat.createSession().then((value) => {
          chat.sendInput(query).then((response) => {
                setState(() {
                  msgs.add(Message(
                      false, response?.output?.generic?[0].toJson()["text"]));
                })
              })
        });
  }

/* -----------------------------------------

      Here is the UI of chatbot screen
--------------------------------------------*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(55, 94, 152, 1),
        title: Text("وجهنّي"),
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
            Expanded(
              child: ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  // reverse: true,
                  itemCount: msgs.length,
                  itemBuilder: (context, index) {
                    // print(msgs[1].msg);
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: index == 0
                            ? BubbleNormal(
                                text: msgs[0].msg,
                                isSender: true,
                                color: Colors.blue.shade100,
                              )

                            // const Padding(
                            //   padding: EdgeInsets.only(left: 16, top: 4),
                            //   child: Align(
                            //       alignment: Alignment.centerLeft,
                            //       child: Text("Typing...")),
                            // )

                            : BubbleNormal(
                                text: msgs[index].msg,
                                isSender: msgs[index].isSender,
                                color: msgs[index].isSender
                                    ? Colors.blue.shade100
                                    : Colors.grey.shade200,
                              ));
                  }),
            ),
            Divider(
              height: 3,
              color: Colors.black,
            ),
            Container(
              color: Color.fromRGBO(129, 154, 190, 1),
              child: ListTile(
                title: Container(
                  // height: ,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: Color.fromRGBO(255, 254, 254, 1),
                  ),
                  padding: EdgeInsets.only(right: 16.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: messageControler,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: "أدخل رسالتك",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      // filled: true,
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
                  onPressed: () {
                    if (messageControler.text.isEmpty) {
                      print("empty message");
                    } else {
                      setState(() {
                        msgs.add(Message(true, messageControler.text));
                        response(messageControler.text.replaceAll("\n", " "));
                        messageControler.clear();
                      });
                    }
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BubbleNormal extends StatelessWidget {
  final String text;
  final bool isSender;
  final Color color;

  BubbleNormal({
    required this.text,
    required this.isSender,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    bool isLongMessage = text.length > 50;
    return Align(
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      child: FractionallySizedBox(
        widthFactor: isLongMessage ? 0.8 : null,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(isSender ? 12.0 : 0.0),
              bottomRight: Radius.circular(isSender ? 0.0 : 12.0),
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          padding: EdgeInsets.all(12.0),
          child: Transform(
            transform: Matrix4.translationValues(
              isSender ? 4.0 : -4.0, // Adjust the value based on your design
              0.0,
              0.0,
            ),
            child: Text(
              text,
              textDirection: ui.TextDirection.rtl,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}
