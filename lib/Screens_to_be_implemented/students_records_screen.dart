import 'package:flutter/material.dart';

class StudentsRecordsScreen extends StatefulWidget {
  const StudentsRecordsScreen({super.key});

  @override
  State<StudentsRecordsScreen> createState() => _StudentsRecordsScreenState();
}

class _StudentsRecordsScreenState extends State<StudentsRecordsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        title: Text("سجل طالباتي"),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
