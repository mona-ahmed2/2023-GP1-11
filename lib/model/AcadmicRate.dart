import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


DateTime dateTime = DateTime.now(); 
 

class AcadmicRate {
  String id = "";
  String studentID = "";
  String studentComment = "";
  int support_direct_rate = 0;
  int rules_know = 0;
  int  attent_fast_resp = 0; 
  int  generalRate = 0; 
  String addedDate = "";  
 

  AcadmicRate(this.id, this.studentID, this.generalRate, this.studentComment, this.attent_fast_resp, this.support_direct_rate, this.rules_know){ 
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
  AcadmicRate.fromDocumentSnapshot(DocumentSnapshot rev, QueryDocumentSnapshot<Map<String, dynamic>> item){
    this.id =  rev["id"] ;
    this.studentID =  rev["studentID"] ;
    this.studentComment =  rev["studentComment"] ;
    this.generalRate =  rev["generalRate"] ;
    this.attent_fast_resp =  rev["attent_fast_resp"] ;
    this.support_direct_rate =  rev["support_direct_rate"] ;
    this.rules_know =  rev["rules_know"] ;
         
    this.addedDate =  rev["addedDate"] ;     
  }

  Map<String, dynamic> toJson() => {'id': id, 'studentID': studentID, 'studentComment': studentComment, "generalRate":generalRate
                          , 'attent_fast_resp': attent_fast_resp, 'support_direct_rate': support_direct_rate,
                          'rules_know':rules_know,
                           'addedDate': addedDate};
}
