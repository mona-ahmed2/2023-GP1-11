import 'package:flutter/material.dart';
import 'package:wjjhni/onlineChatting/chat_dialouge_screen.dart';
import 'package:wjjhni/onlineChatting/chat_tile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:intl/intl.dart' as intl;

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
    names.clear();
    for (var student in snapshot.docs) {
      if (!names.contains(student.get("name"))) {
        names.add(student.get("name"));
        searchResults.add(student.get("name"));
      }
    }
  }
}

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
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
  const MessageStreamBuilder({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
