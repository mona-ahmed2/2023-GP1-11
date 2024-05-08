import 'package:cloud_firestore/cloud_firestore.dart';

class CoursePlan {
  String id = "";
  String course_name = ""; 
  String url = ""; 

  CoursePlan(this.id, this.course_name, this.url);

  CoursePlan.fromDocumentSnapshot(DocumentSnapshot form){
    this.id =  form["id"] ;
    this.course_name =  form["course_name"] ; 
    this.url =  form["url"] ; 
  }

  Map<String, dynamic> toJson() => {'id': id, 'course_name': course_name, 'url': url};
}
