import 'package:flutter/material.dart';

class AbsentCal extends StatefulWidget {
  const AbsentCal({super.key});

  @override
  State<AbsentCal> createState() => _AbsentCalState();
}////////////

class _AbsentCalState extends State<AbsentCal> {
  TextEditingController no_hours_week = TextEditingController();
  TextEditingController no_study_week = TextEditingController();
  double calcResult = 0;

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


  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child:
        Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
              title: Text("حاسبة ساعات الغياب"),
              centerTitle: true,
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("عدد الساعات الفعلية للمقرر خلال الأسبوع الواحد", style: TextStyle(fontSize: 16, ),),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: no_hours_week,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: '',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 16.0),
                  Text("عدد الاسابيع الدراسية خلال الفصل الدراسي", style: TextStyle(fontSize: 16, ),),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: no_study_week,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: '',
                      border: OutlineInputBorder(),
                    ),
                  ),


                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async{
                      String noHoursWeek = no_hours_week.text;
                      String noStudyWeeks = no_study_week.text;
                      if(noStudyWeeks == ""){
                        showAlert(context, "يجب ادخال عدد الساعات الفعلية للمقرر خلال الأسبوع الواحد");
                        return ;
                      }

                      if(noHoursWeek ==""){
                        showAlert(context, "يجب ادخال عدد الاسابيع الدراسية خلال الفصل الدراسي");
                        return ;
                      }
                      setState(() {
                        try{
                          calcResult = double.parse(noStudyWeeks) * double.parse(noHoursWeek) * 0.25;
                        }catch(e){
                          showAlert(context, "يجب ادخال قيم صحيحة");
                        }
                      });

                    },
                    child: Text('احسب ساعات الغياب'),
                  ),

                  SizedBox(height: 16.0),
                  calcResult==0?Container() :Text("ساعات الغياب المتاحة لكِ خلال الفصل الدراسي هي: ", style: TextStyle(fontSize: 16, ),),
                  SizedBox(height: 8.0),
                  calcResult==0?Container() : Text(calcResult.toString() + " ساعة", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold ),),
                ],
              ),
            )
        )
    );
  }
}
