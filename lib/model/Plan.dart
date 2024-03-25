import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wjjhni/model/CoursePlan.dart';

class Plan {
  String id = "";
  String name = ""; 
  List<CoursePlan> couresesList = [];  

  Plan(this.id, this.name);

  Plan.fromDocumentSnapshot(DocumentSnapshot form){
    this.id =  form["id"] ;
    this.name =  form["name"] ; 
  }

  setCourses(List<CoursePlan> couresesList){
    this.couresesList = couresesList;
  }

  List<CoursePlan> getCoursesList(){
    return this.couresesList;
  }
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
