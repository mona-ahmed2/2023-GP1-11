import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wjjhni/model/SpecificNote.dart';

import '../model/BookAppointment.dart';

class StudBookedAppointments extends StatefulWidget {
  const StudBookedAppointments({super.key});

  @override
  State<StudBookedAppointments> createState() => _BookedAppointmentsState();
}

class _BookedAppointmentsState extends State<StudBookedAppointments> {

  String uid = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;

  List<BookAppointment> booksList = [];
  List<DateTimeRange> converted = [];
  String studentName = "";
  showAlert(BuildContext context, String msg) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
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

  cancelConfirmation(BuildContext context, BookAppointment bk)   {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تنبيه', textAlign: TextAlign.end,),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('هل تريد حقا الغاء هذا الموعد؟', textAlign: TextAlign.end,),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {

                Navigator.pop(context, 'Cancel');

              },
              child: const Text('لا'),
            ),
            TextButton(
              onPressed: () async {
                db.collection('booking_appointment') .where('id', isEqualTo: bk.id).get().then(
                        (value) => value.docs.forEach((doc) {
                      // doc.reference.update({'status': -1});
                      doc.reference.delete();
                    }));
                setState(() {
                  booksList.remove(bk);
                  //bk.status = -1;
                });

                db.collection('AvailabilityHours') .where('id', isEqualTo: bk.AvailabilityHoursID).get().then(
                        (value) => value.docs.forEach((doc) {
                      doc.reference.update({'status': 0});
                      //doc.reference.update({'status': -1});
                    }));


                SpecificNote spNote_for_stud = SpecificNote("إلغاء موعد", "تم الغاء الموعد مع مرشدتك", bk.studentID);
                SpecificNote spNote_for_advisor = SpecificNote("إلغاء موعد", "قامت الطالبة/ "+studentName+" بالغاء الموعد", bk.advisorID);


                await FirebaseFirestore.instance.collection('specific_notification').add(spNote_for_stud.toJson()).then((result) {
                }).catchError((error){
                });

                await FirebaseFirestore.instance.collection('specific_notification').add(spNote_for_advisor.toJson()).then((result) {
                }).catchError((error){
                });

                Navigator.pop(context, 'Cancel');
                showAlert(context, "تم الغاء الموعد");
              },
              child: const Text('تأكيد'),
            ),
          ],
        );
      },
    );
  }



  Future<dynamic>? getBookedAppointments() async {
    converted.clear();
    booksList.clear();
    final snapshot = await db
        .collection('booking_appointment')
        .where('studentID', isEqualTo: uid).get().then((value) {
      for (var item in value.docs) {
        setState(() {

          final now = DateTime.now();
          final startDate = DateTime.parse(item['bookingStart']);
          if(!startDate.isBefore(now))
          {
            converted.add(DateTimeRange(
                start: DateTime.parse(item['bookingStart']),
                end: DateTime.parse(item['bookingEnd'])));
            String hoursAvid = item.get("AvailabilityHoursID") ?? "";
            booksList.add(BookAppointment(item["id"],item["bookingStart"],item["bookingEnd"],item["studentID"],item["advisorID"],item["status"],hoursAvid));

          }
        });
      }
    });
    return snapshot;
  }


  @override
  void initState() {
    super.initState();
    getBookedAppointments();
    getStudentName();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        title: Text("مواعيدي المحجوزة"),

        centerTitle: true,
      ),
      body:Directionality(
        textDirection: TextDirection.rtl,
        child: booksList.length == 0?
        Container(
          child: Center(child: Text("لا يوجد حجوزات"),),
        ):
        ListView.builder(
            itemCount: booksList.length,
            itemBuilder: (context, index)
            {
              DateTimeRange e = converted[index];
              BookAppointment bkAppntmtn = booksList[index];
              return Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  border: Border.all(color:const Color.fromRGBO(55, 94, 152, 1) ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
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
                        bkAppntmtn.status == 0 ? IconButton(onPressed: ()async{
                          cancelConfirmation( context, bkAppntmtn);
                        }, icon: Icon(Icons.cancel,color: Colors.red,)) :Container(
                          child: Text("تم الغاء الموعد", style: TextStyle(color: const Color.fromARGB(255, 169, 19, 8),)),
                        ),//trashIcon for cancel appointment


                      ],
                    )
                  ],
                ),
              );

            }
        ),
      ),
    );
  }
}
