import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'all_availability_hours_screen.dart';
import 'availability_hours_screen.dart';


class AvailabilityHomeScreen extends StatefulWidget {
  const AvailabilityHomeScreen({super.key});

  @override
  State<AvailabilityHomeScreen> createState() => _AvailabilityHomeScreenState();
}

class _AvailabilityHomeScreenState extends State<AvailabilityHomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الساعات المتاحة'),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        ),
        body:  Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SvgPicture.asset(
                        'assets/chat.svg',
                        height: 340,
                        width: 400,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      "الإرشاد الأكاديمي\n بين يديك",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.15,
                        color: Color.fromRGBO(55, 94, 152, 1),
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                            "قم بأدراة مواعيدك\n يمكنك حجز وتصفح المواعيد بطريقة اكثر سهولة",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1.15,
                            ),
                          ),
                    Expanded(child: Container()),
                    SizedBox(
                            height: 65,
                            width: 360,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(55, 94, 152, 1),
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const AvailabilityHoursScreen()));
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'حجز المواعيد',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.more_time,
                                        color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 65,
                      width: 360,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(55, 94, 152, 1),
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const AllAvailabilityHoursScreen()));
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'استعراض المواعيد',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.calendar_month, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
