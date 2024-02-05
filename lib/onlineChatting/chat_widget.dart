import 'package:flutter/material.dart';
import 'package:wjjhni/onlineChatting/chat_dialouge_screen.dart';
import 'package:wjjhni/onlineChatting/chat_tile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    for (var student in snapshot.docs) {
      if (!name.contains(student.get("name"))) {
        names.add(student.get("name"));
      }
    }
  }
  searchResults = names;
}

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
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
  const MessageStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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



