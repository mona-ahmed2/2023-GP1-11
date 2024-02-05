import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wjjhni/onlineChatting/new_message.dart';
import 'package:firebase_storage/firebase_storage.dart'
    as firebase_storage; // For File Upload To Firestore
import 'package:path/path.dart' as Path;
import 'dart:io';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
String? email = FirebaseAuth.instance.currentUser!.email;
String uid = FirebaseAuth.instance.currentUser!.uid;
String name = "";
bool isLoading = true;

String stuUID = "";
String advUID = "";
late DocumentSnapshot chatDocument;

class ChatDialouge extends StatefulWidget {
  const ChatDialouge(
      {Key? key,
      required this.otherUserUid,
      required this.isAdvisor,
      required this.isStudent})
      : super(key: key);
  final String otherUserUid;
  final bool isAdvisor;
  final bool isStudent;

  @override
  State<ChatDialouge> createState() => _ChatDialougeState();
}

class _ChatDialougeState extends State<ChatDialouge> {
  String? messageText;

  final TextEditingController _textEditingController = TextEditingController();

  // //function to get messgaes from DB
  // void messagesStreams() async {
  //   await for (var snapshot in _firestore.collection("messages").snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  void setting() {
    if (widget.isAdvisor) {
      advUID = uid;
      stuUID = widget.otherUserUid;
    } else {
      advUID = widget.otherUserUid;
      stuUID = uid;
    }
  }

  Future<String> getName() async {
    setting();
    if (widget.isAdvisor) {
      await for (var snapshot in _firestore
          .collection("students")
          .where("uid", isEqualTo: widget.otherUserUid)
          .snapshots()) {
        for (var student in snapshot.docs) {
          return student.get("name");
        }
      }
    } else {
      await for (var snapshot in _firestore
          .collection("academic_advisors")
          .where("uid", isEqualTo: advUID)
          .snapshots()) {
        for (var advisor in snapshot.docs) {
          return advisor.get('name');
        }
      }
    }

    return "";
  }

  void initState() {
    super.initState();
    setting();
    getName();
  }

  Future<String?> uploadImageToFirebase(XFile imageFile) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images')
          .child('image_${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload file to Firebase Storage
      await ref.putFile(File(imageFile.path));

      // Get download URL
      String downloadURL = await ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

  // Function to save image URL to Firestore
  Future<void> saveImageToFirestore(String imageURL) async {
    try {
      await chatDocument.reference.collection("msglist").add({
        'content': imageURL,
        'type': "image",
        'uid': uid,
        'addtime': FieldValue.serverTimestamp(),
      });
      print('Image URL saved to Firestore');
    } catch (e) {
      print('Error saving image URL to Firestore: $e');
    }
  }

/************************************
 * 
 *          alert Dilouge UI
 ************************************/
  void openMediaDialogue() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            content: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        // print(stuUID);
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "اختاري صورة من الكاميرا أو ألبوم الصور",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () async {
                          final ImagePicker _picker = ImagePicker();
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            String? imageURL =
                                await uploadImageToFirebase(image);
                            if (imageURL != null) {
                              await saveImageToFirestore(imageURL);
                            }
                            Navigator.pop(context);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Icon(
                          Icons.camera_alt,
                          color: const Color.fromRGBO(55, 94, 152, 1),
                          size: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          final ImagePicker _picker = ImagePicker();
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            String? imageURL =
                                await uploadImageToFirebase(image);
                            if (imageURL != null) {
                              await saveImageToFirestore(imageURL);
                            }
                            Navigator.pop(context);
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Icon(
                          Icons.photo_album,
                          color: const Color.fromRGBO(55, 94, 152, 1),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        );
      },
    );
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
        title: FutureBuilder(
            future: getName(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return Text(snapshot.data);
              else
                return Text("");
            }),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            MessageStreamBuilder(),
            Padding(
              padding:
                  const EdgeInsets.only(left: 1, right: 1, bottom: 1, top: 4),
              //bar for sending message
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        print(widget.otherUserUid + 'test');
                        openMediaDialogue();
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
                        if (!(messageText == "" ||
                            messageText == null ||
                            messageText == " ")) if (chatDocument == null) {
                          DocumentReference newDocRef =
                              _firestore.collection("chat").doc();
                          newDocRef.set({
                            'last_msg': messageText,
                            'msg_num': 1,
                            'last_time': new DateTime.now(),
                            'adv_uid': advUID,
                            'stu_uid': stuUID,
                          });
                        }
                        chatDocument.reference.update({
                          'last_time': new DateTime.now(),
                          'last_msg': messageText,
                        });
                        chatDocument.reference.collection("msglist").add({
                          'content': messageText,
                          'type': "text",
                          'uid': uid,
                          'addtime': FieldValue.serverTimestamp(),
                        });
                        setState(() {
                          messageText = "";
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
          ],
        ),
      ),
    );
  }
}

class MesssageLine extends StatelessWidget {
  const MesssageLine({this.text, required this.isMe, Key? key})
      : super(key: key);
  final String? text;

  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Material(
            elevation: 5,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            color: isMe ? Colors.blue[800] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "$text ",
                style: TextStyle(
                    fontSize: 15, color: isMe ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class MessageStreamBuilder extends StatelessWidget {
//   const MessageStreamBuilder({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream:
//             _firestore.collection("chat").snapshots(),
//         builder: (context, snapshot) {
//           List<MesssageLine> messageWidgets = [];
//           if (!snapshot.hasData) {
// //add here spinner
//             return const Center(
//               child: CircularProgressIndicator(backgroundColor: Colors.blue),
//             );
//           }
//           final messages = snapshot.data!.docs.reversed;
//           for (var message in messages) {
//             final messageText = message.get('content');
//             final meesageSenderUid = message.get('uid');
//             final currentUser = uid;

//             final messgeWidget = MesssageLine(
//               text: messageText,
//               isMe: currentUser == meesageSenderUid,
//             );

//             messageWidgets.add(messgeWidget);
//           }
//           return Expanded(
//             child: ListView(
//               reverse: true,
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//               children: messageWidgets,
//             ),
//           );
//         });
//   }
// }

class MessageListBuilder extends StatelessWidget {
  final DocumentSnapshot chatDoc;

  const MessageListBuilder({Key? key, required this.chatDoc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatDoc.reference
          .collection('msglist')
          .orderBy('addtime')
          .snapshots(),
      builder: (context, snapshot) {
        List<MesssageLine> messageWidgets = [];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (/*!snapshot.hasData || */ snapshot.data!.docs.isEmpty) {
          return Expanded(
              child:
                  Center(child: Text('لا توجد رسائل سابقة أبدأ الدردشة الآن')));
        }

        // Accessing documents from the 'msglist' collection inside each 'chat' document
        final List<DocumentSnapshot> msgListDocs = snapshot.data!.docs;
        final messages = snapshot.data!.docs.reversed;
        for (var message in messages) {
          final messageText = message.get('content');
          final meesageSenderUid = message.get('uid');
          final currentUser = uid;

          final messgeWidget = MesssageLine(
            text: messageText,
            isMe: currentUser == meesageSenderUid,
          );

          messageWidgets.add(messgeWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection("chat")
          .where("stu_uid", isEqualTo: stuUID)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(backgroundColor: Colors.blue),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          DocumentReference newDocRef = _firestore.collection("chat").doc();
          newDocRef.set({
            'last_msg': "",
            'msg_num': 0,
            'last_time': new DateTime.now(),
            'adv_uid': advUID,
            'stu_uid': stuUID,
          });

          return Expanded(
            child: Center(
              child: Text("لا توجد رسائل سابقة أبدأ الدردشة الآن"),
            ),
          );
        }
        if (!snapshot.hasData) {
          return Expanded(
            child: Center(
              child: Text("لا توجد رسائل سابقة أبدأ الدردشة الآن"),
            ),
          );
        }

        // Accessing documents from the 'chat' collection
        final List<DocumentSnapshot> chatDocs = snapshot.data!.docs;

        chatDocument = chatDocs[0];
        return MessageListBuilder(chatDoc: chatDocs[0]);
      },
    );
  }
}
