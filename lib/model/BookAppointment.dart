import 'package:cloud_firestore/cloud_firestore.dart';

class BookAppointment {
  String id = "";
  String bookingStart = "";
  String bookingEnd = "";
  String studentID = "";
  String advisorID = ""; 
  String AvailabilityHoursID = ""; 
  int status=0;

  BookAppointment(this.id, this.bookingStart, this.bookingEnd, this.studentID, this.advisorID,  this.status, this.AvailabilityHoursID);

  BookAppointment.fromDocumentSnapshot(DocumentSnapshot bookAppoint){
    this.id =  bookAppoint["id"] ;
    this.bookingStart =  bookAppoint["bookingStart"] ;
    this.bookingEnd =  bookAppoint["bookingEnd"] ;
    this.studentID =  bookAppoint["studentID"] ;
    this.advisorID =  bookAppoint["advisorID"] ;          
    this.status =  bookAppoint["status"] ;     
    this.AvailabilityHoursID =  bookAppoint["AvailabilityHoursID"] ;     
  }

  Map<String, dynamic> toJson() => {'id': id, 'bookingStart': bookingStart, 'bookingEnd': bookingEnd
                          , 'studentID': studentID, 'advisorID': advisorID, 'status': status,
                           'AvailabilityHoursID':AvailabilityHoursID};
}
