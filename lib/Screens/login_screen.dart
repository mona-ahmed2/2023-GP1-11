//import packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wjjhni/Screens/rest_password_screen.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/showSnackbar.dart';
import 'package:toggle_switch/toggle_switch.dart';


class EmailPasswordLogin extends StatefulWidget {//represent the login screen
  static String routeName = '/login-email-password';
  const EmailPasswordLogin({Key? key}) : super(key: key);//constructor

  @override
  _EmailPasswordLoginState createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordLogin> {//the class for the EmailPasswordLogin widget
  final TextEditingController emailController = TextEditingController();// controller for handling the input of the email field
  final TextEditingController passwordController = TextEditingController();//controller for handling the input of the password field
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isObscure = true;//the password text is obscured
  Future<void> loginUser() async {//async method for handling user login by using firebase auth
    try {

      await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      setState(() {
      });
    } on FirebaseAuthException catch (e) {// handles exceptions
      print(e.code.toString());
      String error;
      print(e.code);
      if (e.code == 'weak-password') {
        print('كلمة المرور ضعيفة.');
        error = 'كلمة المرور ضعيفة.';
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS'||e.code == 'invalid-credential') {
        print('لم يتم العثور على الحساب');
        error = 'يوجد خطأ في البريد الالكتروني او كلمة المرور';
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
  int i=0;// initial index for the toggle switch
  @override
  Widget build(BuildContext context) { //override the method to define the interface for the login screen
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
                      initialLabelIndex: i,
                      totalSwitches: 2,
                      inactiveBgColor: Color.fromRGBO(55, 94, 152, 1),
                      inactiveFgColor: Colors.white,
                      labels: const ['مرشد اكاديمي', 'طالب'],
                      onToggle: (index) {
                        i = index!;
                        setState(() {
                        });
                      },
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
                  child: TextField(
                    enabled: true,
                    obscureText: isObscure,
                    keyboardType:TextInputType.visiblePassword,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.transparent, width: 0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.transparent, width: 0),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          isObscure = !isObscure;
                          setState(() {
                          });
                        },
                        child: Icon(
                          isObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color(0xFF14386E),
                        ),
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      filled: true,
                      fillColor: const Color(0xffF5F6FA),
                      hintText:'ادخل كلمة المرور',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => RestPassword()));
                        },
                        child: Text('هل نسيت كلمة المرور؟'))
                  ],
                ),
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
