import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


DateTime dateTime = DateTime.now(); 
 

class AdvisorNote {
  String id = "";
  String category = "";
  String note = "";
  String studentID = "";
  String advisorID = "";  
  String addedDate = "";  
 

  AdvisorNote(this.id, this.category, this.note, this.studentID, this.advisorID){ 
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMMM dd, yyyy').format(now); 
    addedDate = formattedDate.toString();
  }
  
  setAddedDate(var addDate){
    this.addedDate = addDate;
  }

  String getAddedDate(){
    return this.addedDate;
  }
  AdvisorNote.fromDocumentSnapshot(DocumentSnapshot bookAppoint, QueryDocumentSnapshot<Map<String, dynamic>> item){
    this.id =  bookAppoint["id"] ;
    this.category =  bookAppoint["category"] ;
    this.note =  bookAppoint["note"] ;
    this.studentID =  bookAppoint["studentID"] ;
    this.advisorID =  bookAppoint["advisorID"] ;          
    this.addedDate =  bookAppoint["addedDate"] ;     
  }

  Map<String, dynamic> toJson() => {'id': id, 'category': category, 'note': note
                          , 'studentID': studentID, 'advisorID': advisorID, 'addedDate': addedDate};
}
