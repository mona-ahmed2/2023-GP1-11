import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/showSnackbar.dart';
import 'package:toggle_switch/toggle_switch.dart';

class EmailPasswordLogin extends StatefulWidget {
  static String routeName = '/login-email-password';
  const EmailPasswordLogin({Key? key}) : super(key: key);

  @override
  _EmailPasswordLoginState createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> loginUser() async {
    try {

      await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      setState(() {
      });
    } on FirebaseAuthException catch (e) {
      String error;
      print(e.code);
      if (e.code == 'weak-password') {
        print('كلمة المرور ضعيفة.');
        error = 'كلمة المرور ضعيفة.';
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        print('لم يتم العثور على الحساب');
        error = 'لم يتم العثور على الحساب';
      } else if (e.code == 'invalid-email' || e.code == 'wrong-password') {
        print('يوجد خطأ في البريد الالكتروني او كلمة المرور');
        error = 'يوجد خطأ في البريد الالكتروني او كلمة المرور';
      } else {
        error = e.message ?? 'حدث خطأ غير متوقع';
      }
      showSnackBar(
          context, error); // Displaying the usual firebase error message
    }
  }
  bool IsCheck1 =false ;
  bool IsCheck2 =false ;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SingleChildScrollView(
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
                  "تسجيل الدخول",
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20,),
                  child: Center(
                    child: ToggleSwitch(
                      cornerRadius: 20,
                      animate: true,
                      animationDuration: 400,
                      minWidth: 130,
                      initialLabelIndex: 0,
                      totalSwitches: 2,
                      inactiveBgColor: Color.fromRGBO(55, 94, 152, 1),
                      inactiveFgColor: Colors.white,
                      labels: const ['مرشد اكاديمي', 'طالب'],
                      onToggle: (index) {},
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    controller: emailController,
                    hintText: 'ادخل البريد الالكتروني', textInputType: TextInputType.emailAddress, enabled:true,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    controller: passwordController,
                    hintText: 'ادخل كلمة المرور', textInputType: TextInputType.visiblePassword, enabled: true,
                  ),
                ),
                // Row(
                //   children: [
                //     SizedBox(
                //       width: 40,
                //     ),
                //     Text('لم تقم بالتسجيل بعد؟'),
                //     TextButton(
                //         onPressed: () {
                //           Navigator.of(context).push(
                //               MaterialPageRoute(builder: (_) => EmailPasswordSignup()));
                //         },
                //         child: Text('انشاء حساب'))
                //   ],
                // ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                       loginUser();
                    } else {
                      showSnackBar(context,
                          'يرجى ادخال البريد الالكتروني وكلمة المرور',
                      ); // Displaying the usual firebase error message
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    textStyle: MaterialStateProperty.all(
                      const TextStyle(color: Colors.white),
                    ),
                    minimumSize: MaterialStateProperty.all(
                      Size(MediaQuery.of(context).size.width / 2.5, 50),
                    ),
                  ),
                  child: const Text(
                    "تسجيل الدخول",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
