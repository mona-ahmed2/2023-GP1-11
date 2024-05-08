import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'package:wjjhni/onlineChatting/chat_dialouge_screen.dart';
import 'package:wjjhni/onlineChatting/chat_tile.dart';
import '../widgets/note_title.dart';


String adv_uid = FirebaseAuth.instance.currentUser!.uid;
final db = FirebaseFirestore.instance;
ScrollController scrollController = ScrollController();
List<String> names = [];
List<String> IDS = [];
List<String> searchResultsNames = [];
List<String> searchResultsIDs = [];
//function to get names from DB
TextEditingController editingController = TextEditingController();



class StudentsRecordsScreen extends StatefulWidget {
  const StudentsRecordsScreen({super.key});

  @override
  State<StudentsRecordsScreen> createState() => _StudentsRecordsScreenState();
}

class _StudentsRecordsScreenState extends State<StudentsRecordsScreen> {
  /*
  void StudentsStream() async {
    setState(() async {
      await for (var snapshot in db
          .collection("students")
          .where('AdvisorUID', isEqualTo: adv_uid)
          .snapshots()) {
        for (var message in snapshot.docs) {
          print(message.data());
        }
      }
    });
  }
  */

  void filtersearchResultsNames(String query) {

    setState(() {
      searchResultsIDs.clear();
      searchResultsNames.clear();
      if(isNumeric(query)){
        searchResultsIDs = IDS
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }else{
        searchResultsNames = names
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void getNames() async {
    await for (var snapshot in db
        .collection("students")
        .where('AdvisorUID', isEqualTo: adv_uid)
        .snapshots()) {
      for (var student in snapshot.docs) {
        if (!names.contains(student.get("name"))) {

          setState(() {
            names.add(student.get("name"));
            IDS.add(student.get("id"));

          });

        }
      }
    }
    setState(() {
      searchResultsNames = names;
      searchResultsIDs = IDS;

    });
  }

  @override
  void initState() {
    super.initState();
    getNames();
  }

  String filteredName = "";


  @override
  Widget build(BuildContext context) {
    void onQueryChanged(String query) {
      setState(() {
        searchResultsNames = names
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
          title: Text("سجل طالباتي"),
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
                        filtersearchResultsNames(value);
                        setState(() {
                          filteredName = value;
                        });
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
                            filtersearchResultsNames( filteredName );
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
          .where('AdvisorUID', isEqualTo: adv_uid)
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

        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: scrollController,
          shrinkWrap: true,
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            final name = student.get('name');
            final id = student.get('id');
            final stud_id = student.get('uid');

            if(editingController.text == ""){
              return  NoteTile(
                  name: name,
                  id: id,
                  msg: "",
                  time: "",
                  uid: stud_id,
                  adv_uid: adv_uid
              );
            }else
            if (searchResultsNames.contains(name) || searchResultsIDs.contains(id)) {
              return  NoteTile(
                  name: name,
                  id: id,
                  msg: "",
                  time: "",
                  uid: stud_id,
                  adv_uid: adv_uid
              );
            } else {
              return SizedBox(); // Return an empty SizedBox for non-matching items
            }
          },
        );
      },

    );
  }
}
