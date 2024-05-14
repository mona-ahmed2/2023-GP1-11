import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wjjhni/model/CoursePlan.dart';
import 'package:wjjhni/model/Plan.dart';
import 'package:wjjhni/widgets/plan_widget.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  List<Plan> plansList = [];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;


  Future<dynamic>? getPlans() async {
    final snapshot = await db //getting from the firebase database
        .collection('plans') .get().then((value) async {

      List<DocumentSnapshot> documents = value.docs;

      documents.sort((a, b) => a['name'].compareTo(b['name']));
      for (var item in documents)  {

        Plan p = Plan(item["id"],item["name"]);

        await db .collection('plans').doc(p.id).collection("courses") .get().then((value) {
          List<CoursePlan> couresesList = [];
          for (var item in value.docs) {
            setState(() {
              CoursePlan cp = CoursePlan(item["id"],item["course_name"], item["url"]);
              couresesList.add(cp);
            });
          }
          p.setCourses(couresesList);
          plansList.add(p);
        });
      }
    });
    return snapshot;
  }

  @override
  void initState() {
    super.initState();
    getPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        title: Text("الخطط الدراسية"),
        centerTitle: true,
        shadowColor:Colors.black ,
      ),
      body: SafeArea(
        right: true,
        child: Container(
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child:
              Padding(
                padding: const EdgeInsets.only(top:20.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(226, 233, 230, 1),
                      borderRadius: BorderRadius.circular(20),
                    ) ,
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child:GridView(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            mainAxisSpacing: 5,
                          ),
                          shrinkWrap: true,
                          children: List.generate(plansList.length, (index) {
                            Plan pln = plansList[index];
                            return PlanWidget(plan: pln,);
                          }),
                        )
                    )
                ),
              )
          ),
        ),
      ),
    );
  }
}