import 'package:flutter/material.dart';

class BooKAppointment extends StatefulWidget {
  const BooKAppointment({super.key});

  @override
  State<BooKAppointment> createState() => _BooKAppointmentState();
}

class _BooKAppointmentState extends State<BooKAppointment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        title: Text("حجز موعد"),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
