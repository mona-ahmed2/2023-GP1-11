import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wjjhni/model/AdvisorNote.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen(
      {Key? key,
      required this.otherUserUid,
      required this.isAdvisor,
      required this.isStudent,
      required this.studentName, required this.getNotes})
      : super(key: key);
    final String otherUserUid;
    final bool isAdvisor;
    final bool isStudent;
    final String studentName;
    final Future<dynamic>? Function() getNotes;



  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  
  String advisorUID = FirebaseAuth.instance.currentUser!.uid;
  String studentID = "";
  String studentName = "";
  String studentNumber = "";
  final db = FirebaseFirestore.instance;
  
  String selectedCategory = "استشارة أكاديمية";
  TextEditingController noteController = TextEditingController();

  List<String> categories = [ ];
  @override
  void initState() {
    // TODO: implement initState
    categories = [
      'استشارة أكاديمية',
'زيارة سريعة',
'ملاحظة عامة',
'طالبة متعثرة',
'طالبة بظروف صحية',
'طالبة بظروف نفسية', 
'طالبة بظروف اسرية',
'طالبة بظرف خاص',
    ];
    studentID = widget. otherUserUid;
    studentName = widget. studentName;
    getStudentInfo(studentID)!.then((value) { 
        setState(() {
                studentNumber  = value;
        });
      });
    super.initState(); 
  }


  Future<String>? getStudentInfo(String studID) async{ 
    String studentNumber = "";
     await db  
        .collection('students')
        .where('uid', isEqualTo: studID).get().then((value) {
            for (var item in value.docs) {  
                studentNumber = item["id"];  
            }
          }); 
    return studentNumber;
  }
  

  showAlert(BuildContext context, String msg) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تنبيه', textAlign: TextAlign.end,),
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
              child: const Text('OK'),
            ),
             
          ],
        );
      },
    );
  }

   
 
  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      onWillPop: () async {
        widget.getNotes();
        Navigator.pop(context, true);  
        return false; // إيقاف الرجوع الافتراضي
      },
      child:  Directionality(
          textDirection: TextDirection.rtl,
          child:
          Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
          title: Text("اضافة ملاحظة"),
          centerTitle: true,
        ),
        body:Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [   
              Text("اضافة ملاحظة للطالبة ("+studentName+" - "+studentNumber+")", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),         
              SizedBox(height: 16.0),

              DropdownButtonFormField(
                value: selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem(
                    alignment: Alignment.centerRight,
                    value: category,
                    child: Text(category, textAlign: TextAlign.end),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'الفئة',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: noteController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Note',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async{ 
                  String category = selectedCategory ?? '';
                  String note = noteController.text;
                  if(note == ""){
                    showAlert(context, "يجب كتابة نص الاستشارة");
                  }
                  String noteID = FirebaseFirestore.instance.collection('advisor_note').doc().id;
                  AdvisorNote obj = AdvisorNote(noteID, category, note, studentID, advisorUID);
                  await FirebaseFirestore.instance.collection('advisor_note').add(obj.toJson()).then((result) {

                                                                        showAlert(context, "تم اضافة الملاحظة بنجاح.\n\n"
                                                                                           +"تنبيه: هذه الملاحظات خاصة بالمرشدة فقط لا تظهر للطالبة او للادمن فقط للمرشد الاكاديمي / لا يمكن معاينتها الا من قبل المرشد");
                                                                        
                                                                      }).catchError((error){
                                                                      
                                                                        showAlert(context, "خطأ! "+error.toString());
                                                                        
                                                                      });
                  
    
                },
                child: Text('حفظ'),
              ),
              SizedBox(height: 16,),
              const Text("تنبيه: هذه الملاحظات خاصة بالمرشدة فقط لا تظهر للطالبة او للادمن فقط للمرشد الاكاديمي / لا يمكن معاينتها الا من قبل المرشد"),
            ],
          ),
        )
      )
      )
    );
  }
}
