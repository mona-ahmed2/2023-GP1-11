import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:booking_calendar/booking_calendar.dart';

import 'all_availability_hours_screen.dart';


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
    // DateTime.now().startOfDay
    // DateTime.now().endOfDay
    mockBookingService = BookingService(
        userId: uid,
        serviceName: '',
        serviceDuration: 60,
        bookingEnd: DateTime(now.year, now.month, now.day, 18 , ),
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
    a.removeWhere((key, value) => (value==null||value=='')); //delete empty
   await db.collection('AvailabilityHours').add(a);
    if (kDebugMode) {
      print('${a.toString()} has been uploaded');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحديد الاوقات'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        leading: IconButton(onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AllAvailabilityHoursScreen()));
        }, icon: Icon(Icons.edit),),
      ),
      body: Center(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: BookingCalendar(
            availableSlotText: 'المتوفر',
            selectedSlotText: 'المحدد',
            bookedSlotText: 'المختار',
            disabledDays: const [5,6],          //friday+satrday
            bookingService: mockBookingService,
            convertStreamResultToDateTimeRanges: convertStreamResultMock,
            getBookingStream: getBookingStreamMock,
            uploadBooking: uploadBookingMock,
            hideBreakTime: true,
            loadingWidget: const Text('جاري الحصول على المعلومات ...'),
            uploadingWidget: const CircularProgressIndicator(),
            locale: 'ar',
            startingDayOfWeek: StartingDayOfWeek.sunday,
            bookingButtonText: 'اختيار',
            wholeDayIsBookedWidget:
            const Text('تم اختيار جميع الاوقات من 08:00 الى 18:00'),
          ),
        ),
      ),
    );
  }
}