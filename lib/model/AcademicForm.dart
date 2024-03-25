import 'package:cloud_firestore/cloud_firestore.dart';

class AcademicForm {
  String id = "";
  String name = "";
  String file_url = ""; 

  AcademicForm(this.id, this.name, this.file_url);

  AcademicForm.fromDocumentSnapshot(DocumentSnapshot form){
    this.id =  form["id"] ;
    this.name =  form["name"] ;
    this.file_url =  form["file_url"] ; 
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'file_url': file_url};
}
