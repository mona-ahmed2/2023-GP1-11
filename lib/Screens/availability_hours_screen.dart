//import packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:booking_calendar/booking_calendar.dart';
import '../widgets/showSnackbar.dart';


//class by Esraa Alhasan
class AvailabilityHoursScreen extends StatefulWidget {
  const AvailabilityHoursScreen({Key? key}) : super(key: key);
  @override
  State<AvailabilityHoursScreen> createState() => _AvailabilityHoursScreenState();
}

class _AvailabilityHoursScreenState extends State<AvailabilityHoursScreen> {
  final now = DateTime.now();
  late BookingService mockBookingService;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final db =FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    // DateTime.now().startOfDay - to specify the start of the day
    // DateTime.now().endOfDay - to specify the end of the day
    mockBookingService = BookingService(
        userId: uid, //from database
        serviceName: '',
        serviceDuration: 60, //one hour per reservation
        bookingEnd: DateTime(now.year, now.month, now.day, 18 , ), // booking starts from 8AM till 5PM where 6Pm will be the end of the last advising session
        bookingStart: DateTime(now.year, now.month, now.day, 08,));
  }

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    final  snapshot =  db.collection('AvailabilityHours').where('userId',isEqualTo: uid).snapshots();
    return snapshot;
  }

  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking}) async {
    Map<String,dynamic> a =newBooking.toJson();
    a.removeWhere((key, value) => (value==null||value=='')); //delete empty/NULL
   await db.collection('AvailabilityHours').add(a);
    if (kDebugMode) {
      print('${a.toString()} has been uploaded');
    }
    showSnackBar(context,'تم حجز الموعد بنجاح');//massage
  }


  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    List<DateTimeRange> converted = [];
    for (var i = 0; i < streamResult.size; i++) {
      final item = streamResult.docs[i].data();
      converted.add(DateTimeRange(start: DateTime.parse(item['bookingStart']), end: DateTime.parse(item['bookingEnd'])));
    }
    QuerySnapshot a=streamResult;
    for (var element in a.docs) {converted.add(DateTimeRange(start: DateTime.parse(element['bookingStart']), end: DateTime.parse(element['bookingEnd'])));}
    return converted;
  }


  List<DateTimeRange> generatePauseSlots() {
    return [
      DateTimeRange(
          start: DateTime(now.year, now.month, now.day, 12, 0),
          end: DateTime(now.year, now.month, now.day, 13, 0))
    ];
  }


//Interfaces
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تحديد الاوقات'), //Title
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        ),
        body: Center(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: BookingCalendar(
              //each statement has a color to make it easier for the user
              availableSlotText: 'المتوفر',
              selectedSlotText: 'المحدد',
              bookedSlotText: 'المختار',
              disabledDays: const [5,6],          //friday and satrday - weekends
              bookingService: mockBookingService,
              convertStreamResultToDateTimeRanges: convertStreamResultMock,
              getBookingStream: getBookingStreamMock,
              uploadBooking: uploadBookingMock,
              hideBreakTime: true,
              loadingWidget: const Text('جاري الحصول على المعلومات ...'),//recalling informations
              uploadingWidget: const CircularProgressIndicator(),
              locale: 'ar',
              startingDayOfWeek: StartingDayOfWeek.sunday,
              bookingButtonText: 'اختيار',//button only shows if a time slot has been chosen
              wholeDayIsBookedWidget:
              const Text('تم اختيار جميع الاوقات من 08:00 الى 18:00'),//if all times have been reserved/chosen
            ),
          ),
        ),
      ),
    );
  }
}