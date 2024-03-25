//import packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:booking_calendar/booking_calendar.dart';

//class by Esraa Alhasan
class AllAvailabilityHoursScreen extends StatefulWidget {
  const AllAvailabilityHoursScreen({Key? key}) : super(key: key);

  @override
  State<AllAvailabilityHoursScreen> createState() =>
      _AllAvailabilityHoursScreenState();
}


class _AllAvailabilityHoursScreenState
    extends State<AllAvailabilityHoursScreen> {
  final now = DateTime.now();
  late BookingService mockBookingService;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance; 
  @override
  void initState() {
    super.initState();
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
  Stream<dynamic>? getBookingStreamMock() {
    final snapshot = db //getting from the firebase database
        .collection('AvailabilityHours')
        .where('userId', isEqualTo: uid)
        .snapshots();
    return snapshot;
  }

  //to show all reserved appointments
  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking}) async {
    Map<String, dynamic> a = newBooking.toJson();
    a.removeWhere((key, value) => (value == null || value == ''));
    await db.collection('AvailabilityHours').add(a);
    if (kDebugMode) {
      print('${a.toString()} has been uploaded');
    }
  }


  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    List<DateTimeRange> converted = [];
    for (var i = 0; i < streamResult.size; i++) {
      final item = streamResult.docs[i].data();
      converted.add(DateTimeRange(
          start: DateTime.parse(item['bookingStart']),
          end: DateTime.parse(item['bookingEnd'])));
    }

    return converted;
  }


//Design
  List<DateTimeRange> generatePauseSlots() {
    return [
      DateTimeRange(
          start: DateTime(now.year, now.month, now.day, 12, 0),
          end: DateTime(now.year, now.month, now.day, 13, 0))
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('جميع المواعيد'),//Title
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: StreamBuilder<dynamic>(
              stream: getBookingStreamMock(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  List<DateTimeRange> converted = [];
                  for (var i = 0; i < snapshot.data.size; i++) {
                    final item = snapshot.data.docs[i].data();
                    final now = DateTime.now();
                    final startDate = DateTime.parse(item['bookingStart']);
                    if(!startDate.isBefore(now))
                    { 
                      converted.add(DateTimeRange(
                          start: DateTime.parse(item['bookingStart']),
                          end: DateTime.parse(item['bookingEnd'])));
                    }
                  } 
                  /*
                  converted.sort((a,b) {
                    return a.start.compareTo(b.start);
                  });
                  */
                  return converted.length == 0?
                      Container(
                        child: Center(
                          child:  Text("لا يوجد مواعيد متاحة", style: TextStyle(fontSize: 18),)),
                      )
                    : ListView(
                      children: converted
                          .map((e) => 
                          Container(
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
                                    IconButton(onPressed: ()async{
                                      String docId='';
                                      int status=0;
                                      final FirebaseAuth auth = FirebaseAuth.instance;
                                      final String? id = auth.currentUser?.uid;
                                      String a = e.start.toString();
                                      a=a.replaceFirst(' ', 'T');
                                      print(e.start.toString());
                                      await FirebaseFirestore.instance.collection("AvailabilityHours").where('bookingStart',isEqualTo: a).get().then(
                                              (value) => value.docs.forEach((doc) {
                                                docId = doc.get("id");
                                                status = doc.get("status");
                                              }
                                          )
                                        );
                                        if(status==0){ 
                                           await FirebaseFirestore.instance.collection('AvailabilityHours').doc(docId).delete();
                                          
                                           showAlert(context, "تم حذف الموعد بنجاح");
                                        }else{
                                          showAlert(context, "لا يمكن حذف هذا الموعد لارتباطه بحجز");
                                        }

                                    }, icon: Icon(Icons.delete_outline,color: Colors.red,)),//trashIcon for deleting
                                  ],
                                )
                              ],
                            ),
                          )
                          )
                          .toList());
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Center(
                  child: Text("لا يوحد مواعيد"),//none of the times lots has been chosen
                );
              }),
        ),
      ),
    );
  }
}
