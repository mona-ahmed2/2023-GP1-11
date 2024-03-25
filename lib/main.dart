import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:wjjhni/Screens/home_screen.dart';
import 'package:wjjhni/Screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();//flutter binding is initialized for async operations
  await initializeDateFormatting();//initializes date formatting
  await Firebase.initializeApp();//initializes the Firebase
  runApp(const MyApp());//run the app
}


class MyApp extends StatelessWidget {//main application
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl,
     child:   MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(//user interfaces in response to changes in the authentication state
          stream: FirebaseAuth.instance.userChanges(),// method to listen to changes in the user authentication state
          builder: (context, snapshot) {
            if(snapshot.hasData && snapshot.data!=null){

            return const HomeScreen();//home screen if the user is authenticated
            }else if(snapshot.connectionState == ConnectionState.waiting){
              return const SplashScreen();//splash screen while the app is waiting
          }
            return const EmailPasswordLogin();//login screen if the user is not authenticated
          }
        ),
      ),
    );
  }
}
