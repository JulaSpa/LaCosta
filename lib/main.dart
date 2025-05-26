import 'package:flutter/material.dart';
import 'package:la_costa_cereales/pages/inicio.dart';
import 'package:la_costa_cereales/pages/login.dart';
import 'package:la_costa_cereales/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:la_costa_cereales/pages/posiciones.dart';
import 'package:la_costa_cereales/pages/alertas.dart';
import 'package:la_costa_cereales/pages/historicos.dart';
import 'package:la_costa_cereales/pages/buscar.dart';
import 'package:la_costa_cereales/pages/herramientas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? logI = prefs.getBool('logInOut');

  runApp(MyApp(logI: logI));
}

class MyApp extends StatelessWidget {
  final bool? logI;
  const MyApp({Key? key, this.logI}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: logI == false || logI == null ? '/login' : '/home',
      routes: {
        "/inicio": (context) => const Inicio(),
        "/login": (context) => const Login(),
        "/home": (context) => const MyHomePage(),
        "/position": (context) => const Position(),
        "/alertas": (context) => const Alertas(),
        "/historicos": (context) => const Historic(),
        "/buscar": (context) => const Buscar(),
        "/herramientas": (context) => const Tool(),
      },
    );
  }
}
