import 'package:fall/ProfilePage.dart';
import 'package:fall/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'FallDetected.dart';
import 'LoginPage.dart';
import 'firebase_options.dart';
import 'splash.dart';
import 'SignupPage.dart'; // ✅ Import for AuthenticationRepository

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthenticationRepository()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fall Detection',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => SignupPage()),
        GetPage(name: '/home', page: () => SensorHomePage()),
        GetPage(name: '/profile', page: () => ProfilePage())// ✅ Proper home page
      ],
    );
  }
}

