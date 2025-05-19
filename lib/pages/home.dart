import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? username;
  String? password;
  bool? logI;
  String isAccesoTrue = "true"; //USUARIO Y CONTRASEÑA CORRECTO?

  List<dynamic>? posicion;

  List<dynamic>? alertas;
  List? title;

  bool posLista = true;
  bool alertLista = true;
  @override
  void initState() {
    super.initState();
    _initializeData();
    _getStoredUserData();
  }

  void _initializeData() async {
    await Future.wait<List<dynamic>>([
      contarAlertas(),
      contarPosicion(),
    ]);
  }

  //DATA DE SHARED
  Future<void> _getStoredUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    final storedPassword = prefs.getString('password');
    final storedLogI = prefs.getBool("logInOut");
    final storedTitle = prefs.getStringList("m");

    setState(() {
      username = storedUsername;
      password = storedPassword;
      logI = storedLogI;
      title = storedTitle;
    });

    /* print(username);
    print(tok);
    print(alertC);
    print(msjC); */
    print("LOGINOUT");
    print(logI);
    // Verifica si los datos aún no se han enviado antes de cargarlos
  }

  //OBTENER DATOS POSICIÓN
  //contar posicion

  Future<List<dynamic>> contarPosicion() async {
    final prefs = await SharedPreferences.getInstance();
    final usuario = prefs.getString('username');
    final clave = prefs.getString('password');

    final uri = Uri.parse(
      'http://app.lacostacereales.com.ar/api/Documento/Posicion?usuario=$usuario&clave=$clave',
    );

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
      },
    );

    final decoded = jsonDecode(response.body);
    final posicion = decoded['ttDocumento'];

    print("Cantidad de posición: ${posicion.length}");

    setState(() {
      this.posicion = posicion;
      posLista = false;
    });

    return posicion;
  }

  //CONTAR ALERTAS
  Future<List<dynamic>> contarAlertas() async {
    final prefs = await SharedPreferences.getInstance();
    final usuario = prefs.getString('username');
    final clave = prefs.getString('password');

    final uri = Uri.parse(
      'http://app.lacostacereales.com.ar/api/Documento/Alertas?usuario=$usuario&clave=$clave',
    );

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
      },
    );

    final decoded = jsonDecode(response.body);
    final alertas = decoded['ttDocumento'];

    print("Cantidad de alertas: ${alertas.length}");

    setState(() {
      this.alertas = alertas;
      alertLista = false;
    });

    return alertas;
  }

  // Función para manejar la actualización de datos
  Future<void> _refresh() async {
    contarPosicion();
    contarAlertas();
    _getStoredUserData();
    // Simulando una pausa de 2 segundos
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "lib/images/fondo_la_costa.jpg"), // <-- BACKGROUND IMAGE
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        color: Color.fromARGB(255, 0, 0, 0)
            .withOpacity(0.6), // <-- Podés cambiar el color y opacidad
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true, // Desactivamos el automático
          title: Row(
            mainAxisSize: MainAxisSize.min, // evita que se estire demasiado
            children: [
              Image.asset(
                "lib/images/logo_costa.png",
                height: 70, // ajustá el tamaño que te guste
              ),
              const SizedBox(width: 8), // espacio entre el logo y el texto
              const Text(
                "La Costa Cereales SRL",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // o el color que prefieras
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,

          toolbarHeight: 120,
        ),
        body: posLista == true && alertLista == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : isAccesoTrue == "true"
                ? _buildScrollView()
                : _buildErrorText(),
      )
    ]);
  }

  Widget _buildScrollView() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Center(
            child: Wrap(
              spacing: 85, // espacio horizontal entre columnas
              runSpacing: 50, // espacio vertical entre filas
              alignment: WrapAlignment.center,
              children: [
                // MI PERFIL
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/perfil");
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(117, 190, 66, 16),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: Color.fromARGB(117, 190, 66, 16)),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.account_circle_outlined,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 8), // espacio entre cuadrado y texto
                      const Text(
                        "Mi perfil",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // ALERTAS
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/alertas");
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(117, 190, 66, 16),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: Color.fromARGB(117, 190, 66, 16)),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.campaign_rounded,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 8), // espacio entre cuadrado y texto
                      Text(
                        "Alertas (${alertas?.length})",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // POSICION
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/position");
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(117, 190, 66, 16),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: Color.fromARGB(117, 190, 66, 16)),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 8), // espacio entre cuadrado y texto
                      Text(
                        "Posición (${posicion?.length})",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // HISTORICOS
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/historicos");
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(117, 190, 66, 16),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: Color.fromARGB(117, 190, 66, 16)),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.description,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 8), // espacio entre cuadrado y texto
                      const Text(
                        "Históricos",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // HERRAMIENTAS
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/herramientas");
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(117, 190, 66, 16),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: Color.fromARGB(117, 190, 66, 16)),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.build,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 8), // espacio entre cuadrado y texto
                      const Text(
                        "Herramientas",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // CERRAR SESIÓN
                InkWell(
                  onTap: () async {
                    // Cambiar el valor de logI a false y guardarlo en SharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('logInOut', false);

                    // Actualizar el estado en la aplicación
                    setState(() {
                      logI = false;
                    });
                    Navigator.pushNamed(context, "/login");
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(117, 190, 66, 16),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: Color.fromARGB(117, 190, 66, 16)),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 8), // espacio entre cuadrado y texto
                      const Text(
                        "Cerrar sesión",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorText() {
    return InkWell(
      onTap: () async {
        // Cambiar el valor de logI a false y guardarlo en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('logInOut', false);

        // Actualizar el estado en la aplicación
        setState(() {
          logI = false;
        });
        Navigator.pushNamed(context, "/login");
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(94, 232, 250, 0.5),
              Color.fromRGBO(94, 232, 250, 0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(width: 16.0),
            Text(
              "Usuario o contraseña incorrecta",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
