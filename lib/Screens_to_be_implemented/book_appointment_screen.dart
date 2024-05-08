import 'dart:collection';

import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wjjhni/model/AvailabilityHours.dart';
import 'package:wjjhni/model/BookAppointment.dart';
import 'package:wjjhni/model/SpecificNote.dart';
import 'package:wjjhni/onlineChatting/chat_dialouge_screen.dart';

class BooKAppointment extends StatefulWidget {
  final String advisorUid ;
  const BooKAppointment({super.key, required this.advisorUid});

  @override
  State<BooKAppointment> createState() => _BooKAppointmentState();
}

class _BooKAppointmentState extends State<BooKAppointment> {

  final now = DateTime.now();
  late BookingService mockBookingService;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;
  String advName = "";
  String studentName = "";

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

  submitBooking( String docID ,DateTimeRange e) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final String? id = auth.currentUser?.uid;
    String appointmentID = FirebaseFirestore.instance.collection('booking_appointment').doc().id;
    BookAppointment bookAppt= BookAppointment(appointmentID, e.start.toString(), e.end.toString(), id!, widget.advisorUid, 0 , docID);


    SpecificNote spNote_for_stud = SpecificNote("حجز موعد", "تم حجز موعد مع مرشدتك بنجاح", id);
    SpecificNote spNote_for_advisor = SpecificNote("حجز موعد", "قامت الطالبة "+studentName+" بحجز موعد", widget.advisorUid);


    await FirebaseFirestore.instance.collection('specific_notification').add(spNote_for_stud.toJson()).then((result) {
    }).catchError((error){
    });

    await FirebaseFirestore.instance.collection('specific_notification').add(spNote_for_advisor.toJson()).then((result) {
    }).catchError((error){
    });

    await FirebaseFirestore.instance.collection('booking_appointment').add(bookAppt.toJson()).then((result) {

      showAlert(context, "تم حجز الموعد");
      setState(() {
        converted.removeWhere((key, value) => key == docID);
      });

    }).catchError((error){

      showAlert(context, "Error! "+error.toString());

    });
    db.collection('AvailabilityHours')
        .where('id', isEqualTo: docID).get().then(
            (value) => value.docs.forEach((doc) {
          doc.reference.update({'status': 1});
        }
        ));
  }

  confirmProcess(BuildContext context, String docID ,DateTimeRange e) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تنبيه', textAlign: TextAlign.end,),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text("هل تريد تأكيد الحجز؟", textAlign: TextAlign.end,),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('الغاء'),
            ),

            TextButton(
              onPressed: ()async {
                Navigator.pop(context);
                await submitBooking( docID , e);
              },
              child: const Text('تأكيد'),
            ),
          ],
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    getBookingStreamMock();
    // DateTime.now().startOfDay
    // DateTime.now().endOfDay
    mockBookingService = BookingService(
        userId: uid,
        serviceName: '',
        serviceDuration: 60,//duration 60min
        bookingEnd: DateTime(
          now.year,
          now.month,
          now.day,
          18,
        ),
        bookingStart: DateTime(
          now.year,
          now.month,
          now.day,
          08,
        ));
    getAdvisorName();
    getStudentName();
  }

  void getAdvisorName() async {

    await for (var snapshot in db.collection("academic_advisors") .where('uid', isEqualTo: widget.advisorUid).snapshots()) {
      for (var advisorOb in snapshot.docs) {
        setState(() {
          advName = advisorOb.get('name');
        });
      }
    }
  }

  void getStudentName() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final String? id = auth.currentUser?.uid;

    await for (var snapshot in db.collection("students") .where('uid', isEqualTo: id).snapshots()) {
      for (var studObj in snapshot.docs) {
        setState(() {
          studentName = studObj.get('name');
        });
      }
    }
  }

  Map<String, DateTimeRange>converted = HashMap();
  Future<void> getBookingStreamMock() async {
    QuerySnapshot querySnapshot;
    querySnapshot = await db //getting from the firebase database
        .collection('AvailabilityHours')
        .where('userId', isEqualTo: widget.advisorUid)
        .get();
    for (var element in querySnapshot.docs) {
      AvailabilityHours p =  AvailabilityHours.fromDocumentSnapshot(element);
      p.setDocID(element.id);
      bool isBooked =false;
      await checkIfAppintBooked(p.id).then((bool result) {
        if (result) {
          isBooked = true;
        } else {
          isBooked =false;
        }
      });
      setState(() {

        final now = DateTime.now();
        final startDate = DateTime.parse(element['bookingStart']);

        if(!startDate.isBefore(now) && !isBooked)
        {
          converted.addAll(
              {
                element.id :DateTimeRange(
                    start: DateTime.parse(element['bookingStart']),
                    end: DateTime.parse(element['bookingEnd']))
              }
          );
        }
      });
    }
  }

  Future<bool> checkIfAppintBooked(String docID) async {
    final String? id = uid;
    bool booked = false;
    QuerySnapshot querySnapshot;
    querySnapshot = await db //getting from the firebase database
        .collection('booking_appointment').where("AvailabilityHoursID", isEqualTo: docID).get();

    for (var element in querySnapshot.docs) {
      booked = true;
    }
    return booked;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('حجز موعد - مرشدة/ '+advName),//Title
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: converted.length == 0?
          Container(
            child: Center(child: Text("لا يوجد مواعيد متاحة"),),
          ):
          ListView.builder(
            itemCount: converted.length,
            itemBuilder: (BuildContext context, int index) {
              String docID = converted.keys.elementAt(index);
              DateTimeRange e = converted.values.elementAt(index);
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
                      onTap: () async {
                        confirmProcess(context, docID, e);
                      },
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 100,),
                          Column(
                            children: [
                              Text("التاريخ ${e.start.year}/${e.start.month}/${e.start.day}"), //shows in order of the dates
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(" من الساعة ${e.start.hour}"),//mention the hours chosen
                                  SizedBox(width: 10,),
                                  Text("الى الساعة ${e.end.hour}"),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          /*
                                      IconButton(onPressed: ()async{

                                        final FirebaseAuth auth = FirebaseAuth.instance;
                                        final String? id = auth.currentUser?.uid;
                                        String appointmentID = FirebaseFirestore.instance.collection('booking_appointment').doc().id;
                                        BookAppointment bookAppt= BookAppointment(appointmentID, e.start.toString(), e.end.toString(), id!, widget.advisorUid, 0 , docID);
                                        await FirebaseFirestore.instance.collection('booking_appointment').add(bookAppt.toJson()).then((result) {

                                                          showAlert(context, "تم حجز الموعد");
                                                          setState(() {
    converted.removeWhere((key, value) => key == docID);
                                                          });

                                                          }).catchError((error){

                                                            showAlert(context, "Error! "+error.toString());

                                                          });
                                        db.collection('AvailabilityHours')
                                                  .where('id', isEqualTo: docID).get().then(
                                                    (value) => value.docs.forEach((doc) {
                                                        doc.reference.update({'status': 1});
                                                      }
                                                  ));
                                      }, icon: Icon(Icons.add,color: Colors.red,)),//trashIcon for deleting
                                                  */
                        ],
                      ) ,
                    )

                  ],
                ),
              );
            },
          )

          ,
        ),
      ),
    );
  }
}
