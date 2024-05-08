import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:wjjhni/model/AcademicForm.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class AcadFormsScreen extends StatefulWidget {
  const AcadFormsScreen({super.key});

  @override
  State<AcadFormsScreen> createState() => _AcadFormsScreenstate();
}

class _AcadFormsScreenstate extends State<AcadFormsScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance;
  
  List<AcademicForm> formsList = [];  
  
  showLoadingDialog(BuildContext context, String msg) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) { 
<<<<<<< HEAD
          return Directionality(textDirection: TextDirection.rtl,
            child: Dialog(
              // The background color
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(msg)
                  ],
                ),
              ),
            )
=======
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(msg)
                ],
              ),
            ),
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8
          );
        });
  }
 
 
      
  showAlert(BuildContext context , String msg, bool isSuccess) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
<<<<<<< HEAD
        return Directionality(textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('تنبيه', textAlign: TextAlign.end,),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        isSuccess ? Icons.check_circle : Icons.cancel,
                        color: isSuccess ? Colors.green : Colors.red,
                      ),
                    SizedBox(  
                        width: MediaQuery.of(context).size.width * 0.60,
                        height: 60,
                        child:
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 8),
                          child:   
                            Text(
                            msg ,
                              style: const TextStyle(  color: Colors.black87, fontSize: 16), 
                              softWrap: false,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,  
                            ),
                        )
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('OK'),
              ),
            ],
          )
=======
        return AlertDialog(
          title: const Text('تنبيه', textAlign: TextAlign.end,),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      isSuccess ? Icons.check_circle : Icons.cancel,
                      color: isSuccess ? Colors.green : Colors.red,
                    ),
                   SizedBox(  
                      width: MediaQuery.of(context).size.width * 0.60,
                      height: 60,
                      child:
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 8),
                        child:   
                          Text(
                           msg ,
                            style: const TextStyle(  color: Colors.black87, fontSize: 16), 
                            softWrap: false,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,  
                          ),
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('OK'),
            ),
          ],
>>>>>>> c8b7ab0cc01ebb7471171d17c8100898c11a9ff8
        );
      },
    );
  }

  
  void requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      // تم منح الصلاحية بنجاح
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('تم منح الصلاحية'),
            content: Text('لقد تم منح صلاحية استخدام ذاكرة التخزين بنجاح.'),
            actions: [
              TextButton(
                child: Text('موافق'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // الصلاحية لم تتم منحها
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('فشل في منح الصلاحية'),
            content: Text('تعذر منح صلاحية استخدام ذاكرة التخزين.'),
            actions: [
              TextButton(
                child: Text('موافق'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<dynamic>? getAcademicForms() async { 
    formsList.clear();
    final snapshot = await db //getting from the firebase database
        .collection('academic_forms').get().then((value) {
            for (var item in value.docs) { 
                setState(() {
                    formsList.add(AcademicForm(item["id"],item["name"],item["file_url"],));
                    
                }); 
            }
          }); 
    return snapshot;
  }


  @override
  void initState() {
    super.initState();
    requestStoragePermission();
    getAcademicForms();  
      
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        title: Text("النماذج الأكاديمية"),
        centerTitle: true,
      ), 
      body:Directionality(
          textDirection: TextDirection.rtl,
          child: formsList.length == 0?
                Container():
                ListView.builder( 
                        itemCount: formsList.length,
                        itemBuilder: (context, index) 
                        { 
                          AcademicForm formObj = formsList[index];  
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
                                    SizedBox(width: 20,),
                                    Text("نموذج: "+ formObj.name), 
                                     
                                    Spacer(),
                                  
                                    IconButton(onPressed: ()async{ 
                                        showLoadingDialog(context, "بدء التحميل");
                                        final response = await http.get(Uri.parse(formObj.file_url));  
                                        final directory = await getDownloadsDirectory();
                                        final filePath = "${directory!.path}/"+formObj.name+".pdf";
                                        final file = File(filePath);

                                        final downloadTask =   await file.writeAsBytes(response.bodyBytes); 
                                        
                                        Navigator.pop(context);
                                        showAlert(context, "تم التحميل", true);
                                    }, icon: Icon(Icons.download,color: Colors.blue,)),//trashIcon for confirm
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
