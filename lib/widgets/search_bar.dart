import 'package:flutter/material.dart';
class SearchBarCustome extends StatefulWidget {
  @override
  _SearchBarCustomeState createState() => _SearchBarCustomeState();
}

class _SearchBarCustomeState extends State<SearchBarCustome> {
  String query = '';

  void onQueryChanged(String newQuery) {
    setState(() {
      query = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return  Container(
      padding: EdgeInsets.all(16), 
      child: TextField(  
        onChanged: (value){},
        decoration: InputDecoration(
          filled: true,
           fillColor:Colors.white,
          labelText: 'بحث بالاسم' ,
          border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(16.0))),
          suffixIcon: Icon(Icons.search),
        ),),);
  }
}
