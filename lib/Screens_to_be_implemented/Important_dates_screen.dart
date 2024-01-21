import 'package:flutter/material.dart';

class ImportantDatesScreen extends StatefulWidget {
  const ImportantDatesScreen({super.key});

  @override
  State<ImportantDatesScreen> createState() => _ImportantDatesScreenState();
}

class _ImportantDatesScreenState extends State<ImportantDatesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        title: Text("المواعيد المهمة"),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
