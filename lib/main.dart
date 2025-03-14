import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prestapp/firebase_options.dart';
import 'package:prestapp/screens/anualidades/views/anualidades_view.dart';
import 'package:prestapp/screens/home.dart';
import 'package:prestapp/screens/i_compuesto/view/i_compuesto_view.dart';
import 'package:prestapp/screens/i_compuesto/view/montofuturo.dart';
import 'package:prestapp/screens/i_compuesto/view/tasaInteres.dart';
import 'package:prestapp/screens/i_compuesto/view/tiempo.dart';
import 'package:prestapp/screens/i_simple/view/i_simple_view.dart';
import 'package:prestapp/screens/i_simple/view/simple_forms.dart';
import 'package:prestapp/screens/i_simple/view/simple_interes.dart';
import 'package:prestapp/screens/i_simple/view/simple_tiempo.dart';
import 'package:prestapp/screens/login.dart';
import 'package:prestapp/screens/register.dart';
import 'package:prestapp/screens/reset.dart';
import 'package:prestapp/screens/tasa_de_interes%7D/screens/tasa_de_interes_view.dart';
// import 'package:prestapp/screens/t_interes/view/tir_form.dart';

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
        '/ic': (context) => InteresCompuestoView(),
        '/is': (context) => const InteresSimpleView(),
        '/ti': (context) => const InteresCompuestoView(),

        "/is/form": (_) => const SimpleForms(),
        "/is/interes": (_) => const SimpleInteres(),
        "/is/tiempo": (_) => const SimpleTiempo(),
        "/ic/montofuturo": (_) => const Montofuturo(),
        "/ic/tasainteres": (_) => const TasaInteres(),
        "/ic/tiempo": (_) => const Tiempo(),
        "/anualidades": (_) => const AnualidadScreen(),
        "/tasa-interes": (_) =>  InteresCalculadora(),
      },
    );
  }
}
