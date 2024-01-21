import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        title: Text("الخطط الدراسية"),
      centerTitle: true,
      shadowColor:Colors.black ,
      ),
      body: Container(),
    );
  }
}