import 'package:flutter/material.dart';

class AllAppointments extends StatefulWidget {
  const AllAppointments({super.key});

  @override
  State<AllAppointments> createState() => _AllAppointmentsstate();
}

class _AllAppointmentsstate extends State<AllAppointments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        title: Text("مواعيدي"),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
