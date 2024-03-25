import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wjjhni/Screens_to_be_implemented/PdfViewerPage.dart';
import 'package:wjjhni/model/CoursePlan.dart';
import 'package:wjjhni/model/Plan.dart';
class PlanWidget extends StatelessWidget {
  final Plan plan;
  const PlanWidget({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl,
     child:  
        SingleChildScrollView( 
          child:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
              children: [  
                Card(
                  child: Center(
                    child: Column(
                      children: [
                        Text(plan.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16.0),
                        Container( 
                          height: 300, // تحديد الارتفاع المطلوب هنا
                          width: MediaQuery.of(context).size.width * 0.39,
                          child: ListView.builder( 
                              itemCount: plan.couresesList.length,
                              itemBuilder: (context, index) 
                              {
                              CoursePlan cpln = plan.couresesList[index];  
                              return Container(

                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  border: Border.all(color:const Color.fromRGBO(55, 94, 152, 1) ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child:
                                  InkWell(
                                    child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [ 
                                              Text(cpln.course_name),                                                   
                                            ],
                                          )
                                        ],
                                      ),
                                    onTap: () { 
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => PdfViewerPage(crsPln: cpln,)));
                                    },
                                  )
                                  
                                );
                        
                              }
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
        ), 
     ),
                      
                        
     );
  }
}