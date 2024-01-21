
import 'package:flutter/material.dart';
import 'package:wjjhni/Screens/profile_screen.dart';
import 'package:wjjhni/Screens_to_be_implemented/students_records_screen.dart';
import '../Screens_to_be_implemented/Important_dates_screen.dart';
import '../Screens_to_be_implemented/plan_screen.dart';
import '../Screens_to_be_implemented/absent_cal_screen.dart';
import '../Screens_to_be_implemented/acad_forms_screen.dart';

class MoreScreen extends StatelessWidget {
  final bool isAdvisor;
  final bool isStudent;
   MoreScreen({key, required this.isAdvisor, required this.isStudent }): super(key: key);
 
  static final List names = [
    "الخطط الدراسية",
    "النماذج الأكاديمية",   
    "المواعيد المهمة",
    "ملفي الشخصي",
    "سجل طالباتي",
    "حاسبة الغياب"
  ];
  static final List<IconData> icons = [
    Icons.school,
    Icons.file_open,
    Icons.calendar_month,
    Icons.person,
    Icons.book,
    Icons.calculate,
  ];

  static final List<Widget> links = [
    PlanScreen(),
    AcadFormsScreen(),
    ImportantDatesScreen(),
    EmailPasswordSignup(),
    StudentsRecordsScreen(),//replace with profile page
    AbsentCal(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          // mainAxisExtent: 256,
        ),
        itemCount: names.length,
        itemBuilder: (context, i) {
          if (i == 4 && isStudent) {
            // Return an empty container to hide the card
            return Container();
          }
           if (i == 5 && isAdvisor) {
            // Return an empty container to hide the card
            return Container();
          }

          
          return InkWell(
            splashColor: Colors.black,
            borderRadius: BorderRadius.circular(8.0),
            onTap: () async {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => links[i]));
            },
            child: Card(
              // shadowColor: Colors.black,
              // height: 100,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Expanded(
                      child: Icon(
                    icons[i],
                    size: 40.0,
                    color: const Color.fromRGBO(55, 94, 152, 1),
                  )),
                  Text(
                    names[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
