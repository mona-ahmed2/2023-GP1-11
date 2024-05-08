import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wjjhni/model/AdvisorNote.dart';

class ViewNoteScreen extends StatefulWidget {
  const ViewNoteScreen(
      {Key? key,
        required this.note})
      : super(key: key);
  final AdvisorNote note;


  @override
  State<ViewNoteScreen> createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {

  String advisorUID = FirebaseAuth.instance.currentUser!.uid;
  String studentID = "";
  String studentName = "";
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    getStudentInfo(widget.note.studentID);
    super.initState();
  }

  Future<void>? getStudentInfo(String studID) async{
    await db
        .collection('students')
        .where('uid', isEqualTo: widget.note.studentID).get().then((value) {
      for (var item in value.docs) {
        setState(() {

          studentName = item["name"];
        });

      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
          title: Text("تفاصيل الملاحظة"),
          centerTitle: true,
        ),
        body:Directionality(
            textDirection: TextDirection.rtl,
            child:
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("الطالبة: ("+studentName+")", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(height: 16.0),

                  Text("كتبت بتاريخ: ("+widget.note.addedDate+")", style: TextStyle(fontSize: 12,),),
                  SizedBox(height: 16.0),

                  Text("نوع الاستشارة: ("+widget.note.category+")", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                  SizedBox(height: 16.0),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(240, 243, 242, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          widget.note.note,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1C1C1C),
                            height: 1,

                          ),
                        ),
                      )

                  ),
                ],
              ),
            )
        )
    );
  }
}
