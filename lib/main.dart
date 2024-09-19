import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'enter_info_page.dart';
import 'info_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Kontrollera om Firebase redan har initialiserats för att undvika dublett-initialisering
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterV2',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/enterInfo': (context) => const EnterInfoPage(),
        '/info': (context) => const InfoPage(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const LoginPage());
      },
    );
  }
}

