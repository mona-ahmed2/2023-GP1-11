import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


DateTime dateTime = DateTime.now(); 
 

class SpecificNote { 
  Timestamp  date = Timestamp.fromDate( DateTime.now());
  String message = "";
  String title = "";
  String uid = "";   
 

  SpecificNote(this.title, this.message, this.uid){ 
    DateTime now = DateTime.now();
    Timestamp formattedDate = Timestamp.fromDate( now); 
    date = formattedDate;
  }
  
  setDate(var addDate){
    this.date = addDate;
  }

  Timestamp getDate(){
    return this.date;
  }
  SpecificNote.fromDocumentSnapshot(DocumentSnapshot spNote, QueryDocumentSnapshot<Map<String, dynamic>> item){
    this.title =  spNote["title"] ;
    this.message =  spNote["message"] ;
    this.uid =  spNote["uid"] ;
    this.date =  spNote["date"] ; 
  }

  Map<String, dynamic> toJson() => {'title': title, 'message': message, 'uid': uid
                          , 'date': date};
}
