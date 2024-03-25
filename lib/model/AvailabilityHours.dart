import 'package:cloud_firestore/cloud_firestore.dart';

class AvailabilityHours {
  String id = "";
  String bookingStart = "";
  String bookingEnd = "";
  int serviceDuration = 60;
  String userId = "";  

  AvailabilityHours(this.id, this.bookingStart, this.bookingEnd, this.serviceDuration, this.userId, );

  AvailabilityHours.fromDocumentSnapshot(DocumentSnapshot bookAppoint){ 
    this.bookingStart =  bookAppoint["bookingStart"] ;
    this.bookingEnd =  bookAppoint["bookingEnd"] ;
    this.serviceDuration =  bookAppoint["serviceDuration"] ;
    this.userId =  bookAppoint["userId"] ;           
  }

  setDocID(String docID){
    this.id = docID;
  }

  Map<String, dynamic> toJson() => {'id': id, 'bookingStart': bookingStart, 'bookingEnd': bookingEnd
                          , 'serviceDuration': serviceDuration, 'userId': userId};
}
