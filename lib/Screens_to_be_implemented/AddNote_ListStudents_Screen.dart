/*


Removed Class

*/

import 'package:flutter/material.dart';
import 'package:wjjhni/onlineChatting/chat_dialouge_screen.dart';
import 'package:wjjhni/onlineChatting/chat_tile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/note_title.dart';

String adv_uid = FirebaseAuth.instance.currentUser!.uid;
final db = FirebaseFirestore.instance;
ScrollController scrollController = ScrollController();
List<String> names = [];
List<String> searchResults = [];
//function to get names from DB
void getNames() async {
  await for (var snapshot in db
      .collection("students")
      .where('AdvisorUID', isEqualTo: adv_uid)
      .snapshots()) {
    for (var student in snapshot.docs) {
      if (!names.contains(student.get("name"))) {
        names.add(student.get("name"));
      }
    }
  }
  searchResults = names;
}

class AddNote_ListStudents_Screen extends StatefulWidget {
  const AddNote_ListStudents_Screen({super.key});

  @override
  State<AddNote_ListStudents_Screen> createState() => _AddNote_ListStudents_Screen_State();
}

class _AddNote_ListStudents_Screen_State extends State<AddNote_ListStudents_Screen> {
  String nameFilter = "";//filter student names
  /*
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
  }*/

  TextEditingController editingController = TextEditingController();// retrieve the current value text

  void filterSearchResults(String query) {//filter names based on the query
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
          title: Text("اضافة ملاحظة"),
          centerTitle: true,
        ),
        body:
        Directionality(
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
                        setState(() {
                          nameFilter = value;
                        });
                        print(value);
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
                            filterSearchResults(nameFilter);
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
        )
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
          List<NoteTile> noteTiles = [];
          if (!snapshot.hasData) {
            //add here spinner

            return const Center(
              child: CircularProgressIndicator(backgroundColor: Colors.blue),
            );
          }

          final students = snapshot.data!.docs;

          // .where((student) => searchResults.contains(student.get('name')));

          for (var student in students) {
            final name = student.get('name');
            final id = student.get('id');
            final stud_uid = student.get('uid');


            final noteTile = NoteTile(
              name: name,
              id: id,
              msg: "",
              time: "",
              uid: stud_uid,
              adv_uid: adv_uid,
            );
            if (!names.contains(name)) {
              names.add(name);
            }

            noteTiles.add(noteTile);
          }
          return ListView(
            physics: NeverScrollableScrollPhysics(),
            controller: scrollController,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: noteTiles,
          );
        });
  }

}

