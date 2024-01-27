import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wjjhni/Chatbot/message.dart';
import 'package:wjjhni/onlineChatting/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String? email = FirebaseAuth.instance.currentUser!.email;

class ChatDialouge extends StatefulWidget {
  const ChatDialouge({super.key});

  @override
  State<ChatDialouge> createState() => _ChatDialougeState();
}

class _ChatDialougeState extends State<ChatDialouge> {


  String? messageText;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  final TextEditingController _textEditingController = TextEditingController();

  //function to get messgaes from DB
  void messagesStreams() async {
    await for (var snapshot in _firestore.collection("messages").snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  /*************************************************** 

  UI of chat dialouge
  *****************************************************/

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 231, 231, 231),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        title: Text("محادثة طالبة معينة"),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children:[       
                    MessageStreamBuilder(),
                   
            Padding(
              padding:
                  const EdgeInsets.only(left: 1, right: 1, bottom: 1, top: 4),
              //bar for sending message
              child: Container(
                color: Colors.white,
                child:
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            messagesStreams();
                          },
                          icon: Icon(Icons.photo),
                          color: const Color.fromRGBO(55, 94, 152, 1),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _textEditingController,
                            keyboardType: TextInputType.multiline,
                            onChanged: (value) {
                              messageText = value;
                            },
                            maxLines: null,
                            decoration:
                                const InputDecoration(labelText: 'أدخل رسالتك'),
                            autocorrect: true,
                            enableSuggestions: true,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _firestore.collection("messages").add({
                              'content': messageText,
                              'type': "text",
                              'uid': uid,
                              'addtime': DateTime.now(),
                             
                            });
                            setState(() {
                                _textEditingController.clear();
                                FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                            });
                           
                          },
                          icon: Icon(Icons.send),
                          color: const Color.fromRGBO(55, 94, 152, 1),
                        ),
                      ],
                    ),
                 
                ),
              ),
            ],),
          
      ),);
      
    
  }
}

class MesssageLine extends StatelessWidget {
  const MesssageLine({this.text, this.sender, Key? key}): super(key: key);
  final String? text;
  final String? sender;

  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("$sender",style: TextStyle(fontSize: 12,color: Colors.black45),),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(30),
            color: Colors.blue[800],
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "$text ",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
                        stream: _firestore.collection('messages').snapshots(),
                        builder: (context, snapshot) {
                          List<MesssageLine> messageWidgets = [];
                          if (!snapshot.hasData) {

//add here spinner
return const Center(
  child: CircularProgressIndicator(backgroundColor: Colors.blue),
);
                          }
                          final messages = snapshot.data!.docs;
                          for (var message in messages) {
                            final messageText = message.get('content');
                            final meesageSenderUid = message.get('uid');
                            final messgeWidget =MesssageLine(text: messageText,sender: email,);
                              
                            messageWidgets.add(messgeWidget);
                          }
                          return Expanded(
                            child: ListView(
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                              children: messageWidgets,
                            ),
                          );
                        });
  }
}
