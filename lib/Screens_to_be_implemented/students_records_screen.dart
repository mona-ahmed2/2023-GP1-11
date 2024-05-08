import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:string_validator/string_validator.dart';
=======
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8
import 'package:wjjhni/onlineChatting/chat_dialouge_screen.dart';
import 'package:wjjhni/onlineChatting/chat_tile.dart';
import '../widgets/note_title.dart'; 


String adv_uid = FirebaseAuth.instance.currentUser!.uid;
final db = FirebaseFirestore.instance;
ScrollController scrollController = ScrollController();
List<String> names = [];
<<<<<<< HEAD
List<String> IDS = [];
List<String> searchResultsNames = [];
List<String> searchResultsIDs = []; 
//function to get names from DB
  TextEditingController editingController = TextEditingController();

=======
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
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8


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

<<<<<<< HEAD
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
      if (!name.contains(student.get("name"))) {
              
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
=======
  TextEditingController editingController = TextEditingController();

  void filterSearchResults(String query) {
    setState(() {
      searchResults = names
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8

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
<<<<<<< HEAD
        searchResultsNames = names
=======
        searchResults = names
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8
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
<<<<<<< HEAD
                      filtersearchResultsNames(value);
=======
                      filterSearchResults(value);
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8
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
<<<<<<< HEAD
                          filtersearchResultsNames( filteredName );
=======
                          filterSearchResults( filteredName );
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8
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
<<<<<<< HEAD
  
=======
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8
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
<<<<<<< HEAD
            
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
=======

            if (searchResults.contains(name)) {
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8
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
