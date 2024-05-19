import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wjjhni/model/AcadmicRate.dart';
import 'package:wjjhni/widgets/RatingDialog.dart';
import 'package:wjjhni/widgets/starWidget.dart';
//حقي
class RateScreen extends StatefulWidget {
  final String advisorUid ;
  const RateScreen({super.key, required this.advisorUid});

  @override
  State<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  int generalRate = 0;
  int attent_fast_resp = 0;
  int support_direct = 0;
  int rules_know = 0;

  TextEditingController noteController = TextEditingController();


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
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
            title: Text("تقييم مرشدتي"),
            centerTitle: true,
          ),
          body:
          SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [

                    Text("تقييم المرشدة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),

                    SizedBox(height: 16.0),

                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Row(
                        children: [
                          InkWell(
                              onTap: () async {
                                attent_fast_resp = await showDialog(
                                    context: context,
                                    builder: (_) => RatingDialog()
                                );
                                setState(() {
                                  attent_fast_resp= attent_fast_resp;
                                });
                                if(attent_fast_resp == null) return;


                              },
                              child:Row(
                                children:  [
                                  starWidget(selected: (1<=attent_fast_resp)),
                                  starWidget(selected: (2<=attent_fast_resp)),
                                  starWidget(selected: (3<=attent_fast_resp)),
                                  starWidget(selected: (4<=attent_fast_resp)),
                                  starWidget(selected: (5<=attent_fast_resp)),
                                ],
                              )

                          ),
                          Spacer(),
                          Text("التواجد وسرعة الرد",style: TextStyle(fontSize: 16,color: Colors.black),),

                        ],
                      ),
                    ),

                    SizedBox(height: 16.0),

                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Row(
                        children: [
                          InkWell(
                              onTap: () async {
                                support_direct = await showDialog(
                                    context: context,
                                    builder: (_) => RatingDialog()
                                );
                                setState(() {
                                  support_direct= support_direct;
                                });
                                if(support_direct == null) return;


                              },
                              child:Row(
                                children:  [
                                  starWidget(selected: (1<=support_direct)),
                                  starWidget(selected: (2<=support_direct)),
                                  starWidget(selected: (3<=support_direct)),
                                  starWidget(selected: (4<=support_direct)),
                                  starWidget(selected: (5<=support_direct)),
                                ],
                              )

                          ),
                          Spacer(),
                          Text("الدعم والتوجيه المناسب",style: TextStyle(fontSize: 16,color: Colors.black),),

                        ],
                      ),
                    ),

                    SizedBox(height: 16.0),

                    Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Row(
                        children: [
                          InkWell(
                              onTap: () async {
                                rules_know = await showDialog(
                                    context: context,
                                    builder: (_) => RatingDialog()
                                );
                                setState(() {
                                  rules_know= rules_know;
                                });
                                if(rules_know == null) return;


                              },
                              child:Row(
                                children:  [
                                  starWidget(selected: (1<=rules_know)),
                                  starWidget(selected: (2<=rules_know)),
                                  starWidget(selected: (3<=rules_know)),
                                  starWidget(selected: (4<=rules_know)),
                                  starWidget(selected: (5<=rules_know)),
                                ],
                              )

                          ),
                          Spacer(),
                          Text("الإلمام بأنظمة ولوائح الجامعة",style: TextStyle(fontSize: 16,color: Colors.black),),


                        ],
                      ),
                    ),

                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: noteController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          labelText: 'ملاحظات/رسالة الطالبة',
                          border: OutlineInputBorder(),
                          hintTextDirection: TextDirection. rtl
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async{
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final String? studID = auth.currentUser?.uid;
                        String comment = noteController.text;
                        if(noteController.text == "")
                        {
                          showAlert(context, "خطأ! يجب كتابة التعليق");
                          return ;
                        }

                        //String rateID = FirebaseFirestore.instance.collection('ratings').doc(widget.advisorUid).collection("advisor_ratings").doc().id;
                        AcadmicRate obj = AcadmicRate(studID!, studID!,generalRate, comment, attent_fast_resp, support_direct, rules_know);
                        await FirebaseFirestore.instance.collection('ratings').doc(widget.advisorUid).collection("advisor_ratings").doc(studID!).set(obj.toJson()).then((result) {
                          showAlert(context, "تم اضافة الملاحظة بنجاح");

                        }).catchError((error){

                          showAlert(context, "خطأ! "+error.toString());

                        });


                      },
                      child: Text('ارسال التقييم'),
                    ),


                  ],
                )
            ),

          ),

        )
    );
  }
}
