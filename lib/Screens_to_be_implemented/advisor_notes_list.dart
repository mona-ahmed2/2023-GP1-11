import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wjjhni/Screens_to_be_implemented/AddNoteScreen.dart';
import 'package:wjjhni/Screens_to_be_implemented/ViewNoteScreen.dart';

import '../model/AdvisorNote.dart';

class AdvisorNotesList extends StatefulWidget { 
  const AdvisorNotesList({super.key, required this.studentID, required this.advisorID, required this.studentName});
  final String studentID;
  final String studentName;
  final String advisorID;
  @override
  State<AdvisorNotesList> createState() => _advisorNotesListState();
}

class _advisorNotesListState extends State<AdvisorNotesList> {
  
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;
  
  List<AdvisorNote> notesList = [];  

  List<String> studNames = [];
  String _studName= "";
  
  showAlert(BuildContext context, String msg) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text('تنبيه', textAlign: TextAlign.end,),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text(msg, textAlign: TextAlign.end,),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('تم'),
            ),
             
          ],
        );
      },
    );
  } 

   
  
  Future<String>? getStudentInfo(String studID) async{ 
    String studentName = "";
     await db  
        .collection('students')
        .where('uid', isEqualTo: studID).get().then((value) {
            for (var item in value.docs) { 
                studentName = item["name"];
                     
            }
          }); 
    return studentName;
  }
  
  
  Future<dynamic>? getNotes() async { 
    notesList.clear();
    studNames.clear();
    final snapshot = await db //getting from the firebase database
        .collection('advisor_note')
        .where('advisorID', isEqualTo: uid)
        .where('studentID', isEqualTo: widget.studentID).get().then((value) {
            for (var item in value.docs) { 
                    setState(() {  
                        AdvisorNote adv = AdvisorNote(item["id"],
                                                  item["category"],
                                                  item["note"],
                                                  item["studentID"],
                                                  item["advisorID"],);
                        adv.setAddedDate(item["addedDate"]); 
                        notesList.add(adv); 
                        
                    }); 
                    
                    getStudentInfo(item["studentID"])!.then((value) { 
                      setState(() {
                              studNames.add(value);
                      });
                    });
            }
          }); 
    return snapshot;
  }


  @override
  void initState() {
    super.initState();
    getNotes();  
      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        title: Text("قائمة ملاحظات للطالبة/ "+ widget.studentName),

        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(55, 94, 152, 1.0),
          tooltip: 'اضافة ملاحظة',
          onPressed: (){ 
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNoteScreen(otherUserUid:widget.studentID, isAdvisor:false, isStudent: true , studentName: _studName, getNotes: getNotes,)),
              );
          },
          child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body:Directionality(
          textDirection: TextDirection.rtl,
          child: notesList.length == 0?
                Container():
                ListView.builder( 
                        itemCount: notesList.length,
                        itemBuilder: (context, index) 
                        { 
                          AdvisorNote notesObj = notesList[index];   
                          _studName = studNames.length == 0?"..." :  studNames [index];
                          return Container(
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              border: Border.all(color:const Color.fromRGBO(55, 94, 152, 1) ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [ 
                                          Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Container(
                                                width: MediaQuery.of(context).size.width * 0.7,
                                                child:
                                                  Column(
                                                      children: [
                                                        //Center(child:  Text("الطالبه: "+_studName, style:TextStyle(fontWeight: FontWeight.bold) )), 
                                                        /*Text(notesObj.note), */
                                                        Center(child:  Text("نوع الاستشارة: "+notesObj.category, )), 
                                                      ],
                                                    ),
                                                  ),
                                          ),
                                        Spacer(),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.2,
                                          child: Text("كتبت في:  "+notesObj.addedDate),  
                                        ),
                                        ],
                                      ), onTap: () { 

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ViewNoteScreen(note:notesObj,)),
                                            );
                                      },
                                ),
                                
                              ],
                            ),
                          );
                   
                        }
                      ),
                  ), 
    );
  }
}
