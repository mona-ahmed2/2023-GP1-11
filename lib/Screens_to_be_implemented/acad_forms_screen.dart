import 'package:flutter/material.dart';

class AcadFormsScreen extends StatefulWidget {
  const AcadFormsScreen({super.key});

  @override
  State<AcadFormsScreen> createState() => _AcadFormsScreenstate();
}

class _AcadFormsScreenstate extends State<AcadFormsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        title: Text("النماذج الأكاديمية"),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
