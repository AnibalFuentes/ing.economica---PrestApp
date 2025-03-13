import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prestapp/firebase_options.dart';
import 'package:prestapp/screens/home.dart';
import 'package:prestapp/screens/login.dart';
import 'package:prestapp/screens/register.dart';
import 'package:prestapp/screens/reset.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prest-App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
