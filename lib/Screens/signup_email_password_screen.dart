import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wjjhni/model/user_model.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/showSnackbar.dart';

class EmailPasswordSignup extends StatefulWidget {
  const EmailPasswordSignup({Key? key}) : super(key: key);

  @override
  _EmailPasswordSignupState createState() => _EmailPasswordSignupState();
}

class _EmailPasswordSignupState extends State<EmailPasswordSignup> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController completedHoursController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  late bool isUser = false;
  late bool isLoading = true;
  createUser() async {
    var userData;
    final String? id = auth.currentUser?.uid;
    print(id);
    try {
      await db
          .collection('students')
          .where('uid', isEqualTo: id)
          .get()
          .then((value) {
        if (kDebugMode) {
          print(value.docs.first.data());
        }
        if (value.docs.isNotEmpty) {
          userData = UserModel.fromJson(value.docs.first.data());
          emailController.text = userData.email;
          nameController.text = userData.name;
          bioController.text = userData.bio;
          majorController.text = userData.major;
          completedHoursController.text = userData.completedHours;
          isUser = true;
          isLoading = false;
          setState(() {});
        }
      });
    } catch (e) {
      await db
          .collection('academic_advisors')
          .where('uid', isEqualTo: id)
          .get()
          .then((value) {
        if (kDebugMode) {
          print(value.docs.first.data());
        }
        if (value.docs.isNotEmpty) {
          userData = AcademicAdvisorsModel.fromJson(value.docs.first.data());
          emailController.text = userData.email;
          nameController.text = userData.name;
          bioController.text = userData.bio;
          majorController.text = userData.major;
          isUser = false;
          isLoading = false;
          setState(() {});
        }
      });
      if (kDebugMode) {
        print(userData.toString());
      }
    }
  }

  Future<void> update() async {
    try {
      final String? id = auth.currentUser?.uid;
      if (isUser) {
        String docId = '';
        UserModel user = UserModel(
            id: id ?? '',
            name: nameController.text,
            email: emailController.text,
            bio: bioController.text,
            major: majorController.text,
            completedHours: completedHoursController.text);
        await FirebaseFirestore.instance
            .collection("students")
            .where('uid', isEqualTo: id)
            .get()
            .then((value) => print(docId = value.docs.first.reference.id));
        await FirebaseFirestore.instance
            .collection("students")
            .doc(docId)
            .update(user.toJson());
      } else {
        String docId = '';
        AcademicAdvisorsModel user = AcademicAdvisorsModel(
          id: id ?? '',
          name: nameController.text,
          email: emailController.text,
          bio: bioController.text,
          major: majorController.text,
        );
        await FirebaseFirestore.instance
            .collection("academic_advisors")
            .where('uid', isEqualTo: id)
            .get()
            .then((value) => print(docId = value.docs.first.reference.id));
        await FirebaseFirestore.instance
            .collection("academic_advisors")
            .doc(docId)
            .update(user.toJson());
      }
    } on FirebaseAuthException catch (e) {
      // if you want to display your own custom error message
      String error;
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          print('كلمة المرور ضعيفة.');
        }
        error = 'كلمة المرور ضعيفة.';
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('تم استخدام البريد الالكتروني مسبقا');
        }
        error = 'تم استخدام البريد الالكتروني مسبقا';
      } else if (e.code == 'invalid-email') {
        if (kDebugMode) {
          print('يرجى استخدام بريد الكتروني صالح');
        }
        error = 'يرجى استخدام بريد الكتروني صالح';
      } else {
        error = e.message ?? 'حدث خطأ غير متوقع';
      }
      showSnackBar(
          context, error); // Displaying the usual firebase error message
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    createUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(55, 94, 152, 1),
          title: const Text("الملف الشخصي"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_forward)),
          ],
          leading: IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.logout)),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(55, 94, 152, 1),
                    Color.fromRGBO(255, 255, 255, 1),
                  ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                      // Container(
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(10)
                      //   ),
                      //   margin: const EdgeInsets.symmetric(horizontal: 20),
                      //   child: DropdownMenu<String>(
                      //     width:MediaQuery.of(context).size.width-40,
                      //     hintText:'نوع الحساب',
                      //     onSelected: (val){
                      //       role =val!;
                      //       print(role);
                      //       setState(() {
                      //       });
                      //     },
                      //     dropdownMenuEntries: [
                      //       DropdownMenuEntry(value: 'مرشد اكاديمي', label: 'مرشد اكاديمي'),
                      //       DropdownMenuEntry(value: 'طالب', label: 'طالب'),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'الأسم',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            CustomTextField(
                              controller: nameController,
                              hintText: 'الاسم',
                              textInputType: TextInputType.text,
                              enabled: false,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'البريد الالكتروني',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            CustomTextField(
                              controller: emailController,
                              hintText: 'البريد الالكتروني',
                              textInputType: TextInputType.emailAddress,
                              enabled: false,
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 20),
                      // Container(
                      //   margin: const EdgeInsets.symmetric(horizontal: 20),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Padding(
                      //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      //         child: Text('كلمة المرور',style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w400),),
                      //       ),
                      //       CustomTextField(
                      //         controller: passwordController,
                      //         hintText: 'ادخل كلمة السر',
                      //         textInputType: TextInputType.visiblePassword,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'النبذة',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            CustomTextField(
                              controller: bioController,
                              hintText: 'ادخل نبذة عنك',
                              textInputType: TextInputType.text,
                              enabled: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'التخصص',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            CustomTextField(
                              controller: majorController,
                              hintText: 'ادخل التخصص',
                              textInputType: TextInputType.text,
                              enabled: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      isUser
                          ? Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      'الساعات المنتهية من الخطة  ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  CustomTextField(
                                    controller: completedHoursController,
                                    hintText: 'ادخل الساعات',
                                    textInputType: TextInputType.number,
                                    enabled: true,
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      // Row(
                      //   children: [
                      //     SizedBox(
                      //       width: 40,
                      //     ),
                      //     Text('لديك حساب؟'),
                      //     TextButton(
                      //         onPressed: () {
                      //           Navigator.of(context).pop();
                      //         },
                      //         child: Text('قم بتسجيل الدخول'))
                      //   ],
                      // ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          update();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          textStyle: MaterialStateProperty.all(
                            const TextStyle(color: Colors.white),
                          ),
                          minimumSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width / 2.5, 50),
                          ),
                        ),
                        child: const Text(
                          "تحديث",
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
