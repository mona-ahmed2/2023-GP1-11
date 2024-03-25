import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wjjhni/Screens/all_availability_hours_screen.dart';
import 'package:wjjhni/Screens/availability_hours_screen.dart';
import 'package:wjjhni/Screens_to_be_implemented/AddNoteScreen.dart';
import 'package:wjjhni/Screens_to_be_implemented/all_appointments.dart';
import 'package:flutter/material.dart';
import 'package:wjjhni/Screens_to_be_implemented/booked_appointments.dart';

import '../Screens_to_be_implemented/AddNote_ListStudents_Screen.dart';
import '../Screens_to_be_implemented/advisor_notes_list.dart';

class AcademicAppo extends StatefulWidget {
  const AcademicAppo({super.key});

  @override
  State<AcademicAppo> createState() => _AcademicAppoState();
}

class _AcademicAppoState extends State<AcademicAppo> {
  String uid = "";
  final db = FirebaseFirestore.instance;
  
  static final List<String> titles = [
    "إضافة الساعات المتاحة",
    "عرض الساعات المتاحة",
    "عرض مواعيدي المحجوزة",
  ];
  /*
    "اضافة ملاحظة",
    "قائمة الملاحظات"
  */

  List<IconData> icons = [];
  List<Widget> links =[];
  @override
  void initState() {
    super.initState();
      uid = FirebaseAuth.instance.currentUser!.uid;
      icons = [
        Icons.alarm_add,
        Icons.view_agenda,
        Icons.calendar_month,
      ];/*
        Icons.add,
        Icons.list_alt_outlined,
        */
      links = [
        AvailabilityHoursScreen(),
        AllAvailabilityHoursScreen(),
        BookedAppointments(), 
      ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      scrollDirection: Axis.vertical,
      itemCount: titles.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(8.0),
          height: 100,
          child: InkWell(
            onTap: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => links[index]));
            },
            child: Card(
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(titles[index],
                    style: TextStyle(fontSize: 24, color: Colors.black)),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    icons[index],
                    size: 40.0,
                    color: const Color.fromRGBO(55, 94, 152, 1),
                  ),
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
