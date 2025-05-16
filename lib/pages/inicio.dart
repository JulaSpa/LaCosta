import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _Inicio();
}

class _Inicio extends State<Inicio> {
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
          automaticallyImplyLeading: false,
          toolbarHeight: 120,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 170),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/login");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 97, 93, 93),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Clientes"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/camionesCP");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 255, 127, 52),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Camiones"),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                    height: 300), // Espacio entre los botones y el texto
                Container(
                  width: double.infinity,
                  color: Color.fromARGB(117, 190, 66, 16),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0), // Espaciado interno opcional
                  child: const Text(
                    "Experiencia al servicio del agro.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors
                          .white, // Cambiado a negro para que se lea sobre fondo blanco
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
