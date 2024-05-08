import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl,
     child:  SafeArea(
       child:  Padding(
         padding: const EdgeInsets.all(8.0),
         child: Column(children: [
            SvgPicture.asset(
                'assets/undraw_develop_app_re_bi4i.svg',
                width: MediaQuery.of(context).size.width,
                height: 0.5* MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
               SizedBox(
                height: 0.05* MediaQuery.of(context).size.height,
              ),
             Container(
            width: MediaQuery.of(context).size.width,
               child: Card(
                 child: Column(
                   children:[
                    const Text(
                        "\nأهلاً بك في تطبيق وجهنَي ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1.15,
                          color: Color.fromRGBO(55, 94, 152, 1),
                        ),
                      ),
                     
               const Text("\n الإرشاد الأكاديمي بين يديك \n ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.15,
                            color: Color.fromRGBO(156, 180, 204, 1),
                          ),),
                   ], 
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