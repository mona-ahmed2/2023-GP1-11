import 'package:flutter/material.dart';

class AbsentCal extends StatefulWidget {
  const AbsentCal({super.key});

  @override
  State<AbsentCal> createState() => _AbsentCalState();
}

class _AbsentCalState extends State<AbsentCal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        title: Text("حاسبة ساعات الغياب"),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
