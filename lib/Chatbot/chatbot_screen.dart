//import packages
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:wjjhni/Chatbot/message.dart';
import 'package:wjjhni/Chatbot/chatbot_service.dart';


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
  var now = DateTime.now();
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



  @override
  void initState() {
    super.initState();
    msgs.add(Message(
        false," مرحبا بك,\n أنا مساعدك الشخصي للإجابة عن استفساراتك الأكاديمية ومساعدتك نحو التقدم والنجاح الأكاديمي" )

    );

  }

/* -------------------------------------------------------------

this method for sending question and receiving chatbot answer @ibtihalx
-----------------------------------------------------------------*/
  void response(query) async {
    setState(() {
      isTyping = true;
    });

    chat.createSession().then((value) => {
      chat.sendInput(query).then((response) => {
        setState(() {
          msgs.add(Message(
              false, response?.output?.generic?[0].toJson()["text"]));
          isTyping = false;
        })
      })
    });
  }

/* -----------------------------------------

      Here is the UI of chatbot screen
--------------------------------------------*/
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.only(top: 16.0, bottom: 10.0),
            child: Text(
              getDate(),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            itemCount: isTyping ? msgs.length + 1 : msgs.length,
            itemBuilder: (context, index) {
              if (isTyping && index == msgs.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: BubbleNormal(
                    text: 'يكتب',
                    isSender: false,
                    color: Colors.grey.shade200,
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: BubbleNormal(
                    text: msgs[index].msg,
                    isSender: msgs[index].isSender,
                    color: msgs[index].isSender
                        ? Colors.blue.shade100
                        : Colors.grey.shade200,
                  ),
                );
              }
            },
          ),
        ),
        const Divider(
          height: 3,
          color: Colors.black,
        ),
        Container(
          color: const Color.fromRGBO(129, 154, 190, 1),
          child: ListTile(
            title: Container(
              // height: ,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: Color.fromRGBO(255, 254, 254, 1),
              ),
              padding: const EdgeInsets.only(right: 16.0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: messageControler,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  hintText: "أدخل سؤالك",
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  // filled: true,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            leading: InkWell(
              onTap: () {
                if (messageControler.text.isEmpty) {
                  if (kDebugMode) {
                    print("empty message");
                  }
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),

                child: Image.asset(
                  'assets/icons8-chatbot-100.png', // Path to your PNG file
                  width: 36,
                  height: 42,
                ),
              ),
            ),
            // leading: IconButton(
            //   icon: Transform.rotate(
            //     angle: 180 * math.pi / 180,
            //     child: const Icon(
            //       Icons.send,
            //       size: 32,
            //       color: Colors.black38,
            //     ),
            //   ),
            //   onPressed: () {
            //     if (messageControler.text.isEmpty) {
            //       if (kDebugMode) {
            //         print("empty message");
            //       }
            //     } else {
            //       setState(() {
            //         msgs.add(Message(true, messageControler.text));
            //         response(messageControler.text.replaceAll("\n", " "));
            //         messageControler.clear();
            //       });
            //     }
            //     FocusScopeNode currentFocus = FocusScope.of(context);
            //     if (!currentFocus.hasPrimaryFocus) {
            //       currentFocus.unfocus();
            //     }
            //   },
            // ),
          ),
        ),
      ],
    );
  }
}

class BubbleNormal extends StatelessWidget {
  final String text;
  final bool isSender;
  final Color color;

  const BubbleNormal({
    super.key,
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
              topLeft: const Radius.circular(12.0),
              topRight: const Radius.circular(12.0),
            ),
          ),
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          padding: const EdgeInsets.all(12.0),
          child: Transform(
            transform: Matrix4.translationValues(
              isSender ? 4.0 : -4.0, // Adjust the value based on your design
              0.0,
              0.0,
            ),
            child: Text(
              text,
              textDirection: ui.TextDirection.rtl,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}