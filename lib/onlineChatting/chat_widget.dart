import 'package:flutter/material.dart';
import 'package:wjjhni/onlineChatting/chat_dialouge_screen.dart';
import 'package:wjjhni/onlineChatting/chat_tile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
<<<<<<< HEAD
import 'package:firebase_auth/firebase_auth.dart'; 
=======
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:intl/intl.dart' as intl;
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8

String uid = FirebaseAuth.instance.currentUser!.uid;
final db = FirebaseFirestore.instance;
ScrollController scrollController = ScrollController();
List<String> names = [];
List<String> searchResults = [];
//function to get names from DB
void getNames() async {
  await for (var snapshot in db
      .collection("students")
      .where('AdvisorUID', isEqualTo: uid)
      .snapshots()) {
<<<<<<< HEAD
    for (var student in snapshot.docs) {
      if (!name.contains(student.get("name"))) {
        names.add(student.get("name"));
      }
    }
  }
  searchResults = names;
=======
    names.clear();
    for (var student in snapshot.docs) {
      if (!names.contains(student.get("name"))) {
        names.add(student.get("name"));
        searchResults.add(student.get("name"));
      }
    }
  }
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8
}

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
<<<<<<< HEAD
  void StudentsStream() async {
    setState(() async {
      await for (var snapshot in db
          .collection("students")
          .where('AdvisorUID', isEqualTo: uid)
          .snapshots()) {
        for (var message in snapshot.docs) {
          print(message.data());
        }
      }
    });
  }
=======
  // void StudentsStream() async {
  //   setState(() async {
  //     await for (var snapshot in db
  //         .collection("students")
  //         .where('AdvisorUID', isEqualTo: uid)
  //         .snapshots()) {
  //       for (var message in snapshot.docs) {
  //         print(message.data());
  //       }
  //     }
  //   });
  // }
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8

  TextEditingController editingController = TextEditingController();

  void filterSearchResults(String query) {
    setState(() {
      searchResults = names
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getNames();
  }

  @override
  Widget build(BuildContext context) {
    void onQueryChanged(String query) {
      setState(() {
        searchResults = names
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                    // print(getStudentsStream());
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'بحث بالاسم',
                    border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0))),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        print(names.length);
                      },
                    ),
                  ),
                ),
              ),
              MessageStreamBuilder(),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
<<<<<<< HEAD
  const MessageStreamBuilder({super.key});
=======
  const MessageStreamBuilder({Key? key});
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
<<<<<<< HEAD
        stream: db
            .collection("students")
            .where('AdvisorUID', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          List<ChatTile> chatTiles = [];
          if (!snapshot.hasData) {
            //add here spinner

            return const Center(
              child: CircularProgressIndicator(backgroundColor: Colors.blue),
            );
          }

          final students = snapshot.data!.docs;
          
          // .where((student) => searchResults.contains(student.get('name')));

          for (var student in students) {
            // final String name;
            // final String id;
            // final String msg;
            // final String time;
            final name = student.get('name');
            final id = student.get('id');
            final uid = student.get('uid');
            

            final chatTile = ChatTile(
              name: name,
              id: id,
              msg: "",
              time: "6 صباحا",
              uid: uid,
            );
            if (!names.contains(name)) {
              names.add(name);
            }

            chatTiles.add(chatTile);
          }
          return ListView(
            physics: NeverScrollableScrollPhysics(),
            controller: scrollController,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: chatTiles,
          );
        });
  }

  Future<String> getLastMessgeInfo(String uid) async {
    await for (var snapshot
        in db.collection("chat").where("stu_uid", isEqualTo: uid).snapshots()) {
     
      for (var chat in snapshot.docs) {
        return chat.get('last_msg');
   
      }
     
    }
   return "";
  }
}



=======
      stream: db
          .collection("students")
          .where('AdvisorUID', isEqualTo: uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(backgroundColor: Colors.blue),
          );
        }

        final students = snapshot.data!.docs;

        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: scrollController,
          shrinkWrap: true,
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            final name = student.get('name');
            final id = student.get('id');
            final uid = student.get('uid');

            if (searchResults.contains(name)) {
              return FutureBuilder<DocumentSnapshot?>(
                future: getLastMessageInfo(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    String lastMessage = "";
                    String formattedTime = '';
                    int msg_num = 0;
                    if (snapshot.data != null && snapshot.hasData) {
                      lastMessage = snapshot.data!.get('last_msg') ?? "";
                      msg_num = snapshot.data!.get('msg_num') ?? 0;
                      final time = snapshot.data!.get('last_time') ?? "";

                      if (time != null) {
                        DateTime dateTime = (time as Timestamp).toDate();

                        formattedTime =
                            intl.DateFormat.yMMMd('ar').format(dateTime);
                      }
                    } else {
                      lastMessage = "";
                      formattedTime = "";
                    }

                    return ChatTile(
                      name: name,
                      id: id,
                      msg: lastMessage,
                      time: formattedTime,
                      uid: uid,
                      numberOfmessages: msg_num,
                    );
                  }
                },
              );
            } else {
              return SizedBox(); // Return an empty SizedBox for non-matching items
            }
          },
        );
      },
    );
  }

  Future<DocumentSnapshot?> getLastMessageInfo(String uid) async {
    try {
      final snapshot = await db
          .collection("chat")
          .where("stu_uid", isEqualTo: uid)
          .orderBy('last_time', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first;
      }
    } catch (e) {
      print('Error retrieving last message: $e');
    }

    return null; // Return null if no document is found or an error occurs
  }
}

>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8
