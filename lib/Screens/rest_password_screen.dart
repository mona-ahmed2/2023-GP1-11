import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/showSnackbar.dart';

class RestPassword extends StatefulWidget {
  static String routeName = '/rest_password';
  const RestPassword({Key? key}) : super(key: key);

  @override
  _RestPasswordState createState() => _RestPasswordState();
}


class _RestPasswordState extends State<RestPassword> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> restPassword() async {//shows a loading dialog
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context)=>const Center(child: CircularProgressIndicator(),));
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);//the message
      showSnackBar(context,'تم ارسال الايميل بنجاح');
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } on  FirebaseAuthException catch (e) {
      Navigator.of(context).pop();

      print(e.code.toString());
      String error;
      print(e.code);
      if (e.code == 'weak-password') {
        print('كلمة المرور ضعيفة.');
        error = 'كلمة المرور ضعيفة.';
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS'||e.code == 'invalid-credential') {
        print('لم يتم العثور على الحساب');
        error = 'لم يتم العثور على الحساب';
      } else if (e.code == 'invalid-email' || e.code == 'wrong-password') {
        print('يوجد خطأ في البريد الالكتروني او كلمة المرور');
        error = 'يوجد خطأ في البريد الالكتروني ';
      } else {
        error = e.message ?? 'حدث خطأ غير متوقع';
      }
      showSnackBar(
          context, error); // Displaying the usual firebase error message
    }
  }
  @override
  void dispose() {
   emailController.dispose();
    super.dispose();//free resources
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar:AppBar(
          title: Text('استعادة كلمة المرور'),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
        ) ,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(55, 94, 152, 1),
                  Color.fromRGBO(255, 255, 255, 1),
                ], begin: Alignment.topRight, end: Alignment.bottomLeft),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "اعادة تعيين كلمة المرور",
                    style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "سيتم ارسال ايميل لاعادة تعيين كلمة المرور",
                    style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w200),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomTextField(
                      controller: emailController,
                      hintText: 'ادخل البريد الالكتروني', textInputType: TextInputType.emailAddress, enabled:true,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: ElevatedButton.icon(
                      onPressed: () async{
                        if (emailController.text.isNotEmpty ) {
                          restPassword();
                        } else {
                          showSnackBar(context,
                              'يرجى ادخال البريد الالكتروني',
                          ); // Displaying the usual firebase error message
                        }
                      },
                      style: ButtonStyle(
                        alignment: Alignment.center,
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        textStyle: MaterialStateProperty.all(
                          const TextStyle(color: Colors.white),
                        ),
                        minimumSize: MaterialStateProperty.all(
                          Size(MediaQuery.of(context).size.width /1.5, 50),
                        ),
                      ),
                      icon: Icon(Icons.email_outlined),
                      label:const Text(
                        "اعادة تعيين",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
