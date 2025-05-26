import 'package:flutter/material.dart';

/* import 'package:http/http.dart' as http; */

class Tool extends StatefulWidget {
  const Tool({super.key});

  @override
  State<Tool> createState() => _ToolState();
}

class _ToolState extends State<Tool> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/images/fondo_la_costa.jpg"),
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
            automaticallyImplyLeading: true,
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
          body: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color.fromARGB(22, 0, 0, 0),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 0.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.white24, width: 1),
                        bottom: BorderSide(color: Colors.white24, width: 1),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: InkWell(
                        // Cambiamos GestureDetector por InkWell para efecto visual
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              insetPadding: const EdgeInsets.only(
                                top:
                                    1, // más chico que 16 → más alto el diálogo
                                left: 10,
                                right: 10,
                                bottom: 1,
                              ),
                              child: InteractiveViewer(
                                panEnabled: true,
                                minScale: 0.5,
                                maxScale: 5,
                                child: Image.network(
                                  'http://www.lacostacereales.com.ar/assets/images/gastos-1-1066x642.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                        splashColor: Colors.white24, // efecto de toque
                        highlightColor: Colors
                            .white10, // efecto mientras se mantiene presionado
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 62.0,
                              right: 62.0,
                              top: 20.0,
                              bottom: 20), // separación del borde
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.engineering_outlined,
                                color: Colors.white,
                                size: 60,
                              ),
                              SizedBox(
                                  width: 16), // espacio entre ícono y texto
                              Expanded(
                                child: Text(
                                  "Gastos de secada",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18, // texto más grande
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 0.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white24, width: 1),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: InkWell(
                        // Cambiamos GestureDetector por InkWell para efecto visual
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              insetPadding: const EdgeInsets.only(
                                top:
                                    1, // más chico que 16 → más alto el diálogo
                                left: 10,
                                right: 10,
                                bottom: 1,
                              ),
                              child: InteractiveViewer(
                                panEnabled: true,
                                minScale: 0.5,
                                maxScale: 5,
                                child: Image.network(
                                  'http://www.lacostacereales.com.ar/assets/images/tipos-de-camiones-que-reciben-las-plantas-974x1316.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                        splashColor: Colors.white24, // efecto de toque
                        highlightColor: Colors
                            .white10, // efecto mientras se mantiene presionado
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 62.0,
                              right: 62.0,
                              top: 20.0,
                              bottom: 20), // separación del borde
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.car_crash_outlined,
                                color: Colors.white,
                                size: 60,
                              ),
                              SizedBox(
                                  width: 16), // espacio entre ícono y texto
                              Expanded(
                                child: Text(
                                  "Tipos de camiones admitidos en puertos",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18, // texto más grande
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 0.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white24, width: 1),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: InkWell(
                        // Cambiamos GestureDetector por InkWell para efecto visual
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              insetPadding: const EdgeInsets.only(
                                top:
                                    1, // más chico que 16 → más alto el diálogo
                                left: 10,
                                right: 10,
                                bottom: 1,
                              ),
                              child: InteractiveViewer(
                                panEnabled: true,
                                minScale: 0.5,
                                maxScale: 5,
                                child: Image.network(
                                  'http://lacostacereales.com.ar/assets/images/acondiciona-1400x774.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                        splashColor: Colors.white24, // efecto de toque
                        highlightColor: Colors
                            .white10, // efecto mientras se mantiene presionado
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 62.0,
                              right: 62.0,
                              top: 20.0,
                              bottom: 20), // separación del borde
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.money_outlined,
                                color: Colors.white,
                                size: 60,
                              ),
                              SizedBox(
                                  width: 16), // espacio entre ícono y texto
                              Expanded(
                                child: Text(
                                  "Tarifa de acondicionadoras",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18, // texto más grande
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 0.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white24, width: 1),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: InkWell(
                        // Cambiamos GestureDetector por InkWell para efecto visual
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              insetPadding: const EdgeInsets.only(
                                top:
                                    1, // más chico que 16 → más alto el diálogo
                                left: 10,
                                right: 10,
                                bottom: 1,
                              ),
                              child: InteractiveViewer(
                                panEnabled: true,
                                minScale: 0.5,
                                maxScale: 5,
                                child: Image.network(
                                  'http://www.lacostacereales.com.ar/assets/images/plantas2-1079x2679.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                        splashColor: Colors.white24, // efecto de toque
                        highlightColor: Colors
                            .white10, // efecto mientras se mantiene presionado
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 62.0,
                              right: 62.0,
                              top: 20.0,
                              bottom: 20), // separación del borde
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_rounded,
                                color: Colors.white,
                                size: 60,
                              ),
                              SizedBox(
                                  width: 16), // espacio entre ícono y texto
                              Expanded(
                                child: Text(
                                  "Códigos en puertos y plantas",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18, // texto más grande
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 0.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white24, width: 1),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: InkWell(
                        // Cambiamos GestureDetector por InkWell para efecto visual
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              insetPadding: const EdgeInsets.only(
                                top:
                                    1, // más chico que 16 → más alto el diálogo
                                left: 10,
                                right: 10,
                                bottom: 1,
                              ),
                              child: InteractiveViewer(
                                panEnabled: true,
                                minScale: 0.5,
                                maxScale: 5,
                                child: Image.network(
                                  'http://www.lacostacereales.com.ar/assets/images/tolerancia-blnz-627x326.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                        splashColor: Colors.white24, // efecto de toque
                        highlightColor: Colors
                            .white10, // efecto mientras se mantiene presionado
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 62.0,
                              right: 62.0,
                              top: 20.0,
                              bottom: 20), // separación del borde
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.line_weight,
                                color: Colors.white,
                                size: 60,
                              ),
                              SizedBox(
                                  width: 16), // espacio entre ícono y texto
                              Expanded(
                                child: Text(
                                  "Tolerancia en balanzas",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18, // texto más grande
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 0.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white24, width: 1),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: InkWell(
                        // Cambiamos GestureDetector por InkWell para efecto visual
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              insetPadding: const EdgeInsets.only(
                                top:
                                    1, // más chico que 16 → más alto el diálogo
                                left: 10,
                                right: 10,
                                bottom: 1,
                              ),
                              child: InteractiveViewer(
                                panEnabled: true,
                                minScale: 0.5,
                                maxScale: 5,
                                child: Image.network(
                                  'http://www.lacostacereales.com.ar/assets/images/cupo-1400x665.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                        splashColor: Colors.white24, // efecto de toque
                        highlightColor: Colors
                            .white10, // efecto mientras se mantiene presionado
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 62.0,
                              right: 62.0,
                              top: 20.0,
                              bottom: 20), // separación del borde
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                color: Colors.white,
                                size: 60,
                              ),
                              SizedBox(
                                  width: 16), // espacio entre ícono y texto
                              Expanded(
                                child: Text(
                                  "Horarios de cupos",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18, // texto más grande
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
