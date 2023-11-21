import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:wjjhni/Screens/home_screen.dart';
import 'package:wjjhni/Screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data!=null){
           //FirebaseAuth.instance.signOut();
          return const HomeScreen();
          }else if(snapshot.connectionState == ConnectionState.waiting){
            return const SplashScreen();
        }
          return const EmailPasswordLogin();
        }
      ),
    );
  }
}
