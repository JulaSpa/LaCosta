import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:la_costa_cereales/album/album.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:la_costa_cereales/pages/detalles.dart';

class Buscar extends StatefulWidget {
  const Buscar({super.key});

  @override
  State<Buscar> createState() => _BuscarState();
}

class _BuscarState extends State<Buscar> {
  String? username;
  String? password;
  String? fromDate;
  String? toDate;
  String? nroCp;
  Future<List<Album>> futureAlbum = Future.value([]);
  bool isLoading = true;
//BUSCAR POR PALABRA CLAVE
  var searchController = TextEditingController();
  String ordenarPor = 'Seleccionar';
  @override
  void initState() {
    super.initState();
    // Obtener los valores de SharedPreferences
    _getStoredUserData();
    ordenarPor = 'Seleccionar';
  }

  Future<void> _getStoredUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      password = prefs.getString('password');
      nroCp = prefs.getString("cpBuscarPage");
      fromDate = prefs.getString('fromDate');
      toDate = prefs.getString('toDate');
    });
    _loadAlbumData();
    if (username != null &&
        password != null &&
        fromDate != null &&
        toDate != null) {
      futureAlbum = fetchAlbum();
    }
  }

  void _loadAlbumData() {
    futureAlbum = fetchAlbum().then((result) {
      return result;
    }).catchError((error) {
      print("Error fetching album: $error");
      return <Album>[]; // Devuelve una lista vacía en caso de error.
    }).whenComplete(() {
      setState(() {
        // Cuando se complete la operación, establece isLoading en falso.
        isLoading = false;
      });
    });
  }

  Future<List<Album>> fetchAlbum() async {
    final usuario = username;
    final clave = password;
    final nrocp = nroCp;

    final regExp = RegExp(r'^(\d{4})-(\d{2})-(\d{2})');
    final fechad = fromDate != null ? regExp.firstMatch(fromDate!) : null;
    final fechah = toDate != null ? regExp.firstMatch(toDate!) : null;

    String fechaFormateadaD = '';
    String fechaFormateadaH = '';
    if (fechad != null) {
      final anio = fechad.group(1);
      final mes = fechad.group(2);
      final dia = fechad.group(3);
      fechaFormateadaD = '$dia/$mes/$anio';
    } else {
      fechaFormateadaD = "";
    }
    if (fechah != null) {
      final anio = fechah.group(1);
      final mes = fechah.group(2);
      final dia = fechah.group(3);
      fechaFormateadaH = '$dia/$mes/$anio';
    } else {
      fechaFormateadaH = "";
    }
    print("datos");
    print(usuario);
    print(clave);
    print(nrocp);
    print(fechaFormateadaD);
    print(fechaFormateadaH);
    final uri = Uri.parse(
      'http://app.lacostacereales.com.ar/api/Documento/historicos?usuario=$usuario&clave=$clave&nrocp=$nrocp&fechad=$fechaFormateadaD&fechah=$fechaFormateadaH ',
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
    print("decoded");
    print(decoded);
    final posicion = decoded['ttDocumento'];
    print("buscar");
    print(posicion);
    try {
      final List<dynamic> responseJson = posicion;

      print(responseJson);
      final List<Album> albums =
          responseJson.map((albumJson) => Album.fromJson(albumJson)).toList();
      return albums;
    } catch (e) {
      print("Error decoding JSON: $e");
      throw Exception('Failed to decode JSON');
    }
  }

  bool isOptionsVisible = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "lib/images/fondo_la_costa.jpg"), // <-- BACKGROUND IMAGE
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
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
            backgroundColor: Color.fromARGB(117, 0, 0, 0),
            centerTitle: true,

            toolbarHeight: 120,
          ),
          body: DecoratedBox(
            decoration:
                const BoxDecoration(color: Color.fromARGB(117, 0, 0, 0)),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Column(
                        children: [
                          if (isOptionsVisible)
                            ListTile(
                              title: TextField(
                                controller: searchController,
                                decoration: const InputDecoration(
                                  hintText: 'Buscar por palabra clave',
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    // Actualizar el estado del controlador
                                    searchController.text = text;
                                  });
                                },
                              ),
                            ),
                          // Ordenar por
                          if (isOptionsVisible)
                            // Ordenar por

                            OptionWidget(
                              title: 'Ordernar por:',
                              selectedValue: ordenarPor,
                              onSelected: (value) {
                                setState(() {
                                  ordenarPor = value;
                                });
                                print('Opción seleccionada: $value');
                              },
                            ),
                        ],
                      ),
                      Expanded(
                        child: FutureBuilder<List<Album>>(
                          future: futureAlbum,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var albums = snapshot.data!;
                              // Filtrar la lista según el texto del searchController
                              var filteredAlbums = albums
                                  .where((album) =>
                                      album.nroCP.toLowerCase().startsWith(searchController.text.toLowerCase()) ||
                                      album.xtitular.toLowerCase().startsWith(
                                          searchController.text
                                              .toLowerCase()) ||
                                      album.xcorredor.toLowerCase().startsWith(
                                          searchController.text
                                              .toLowerCase()) ||
                                      album.xdestinatario
                                          .toLowerCase()
                                          .startsWith(searchController.text
                                              .toLowerCase()) ||
                                      album.xdestino.toLowerCase().startsWith(
                                          searchController.text
                                              .toLowerCase()) ||
                                      album.nombrePrc.toLowerCase().startsWith(
                                          searchController.text.toLowerCase()) ||
                                      album.chasisFl.toLowerCase().startsWith(searchController.text.toLowerCase()) ||
                                      album.rem2.toLowerCase().startsWith(searchController.text.toLowerCase()) ||
                                      album.remCom.toLowerCase().startsWith(searchController.text.toLowerCase()) ||
                                      album.rem1.toLowerCase().startsWith(searchController.text.toLowerCase()) ||
                                      album.rem3.toLowerCase().startsWith(searchController.text.toLowerCase()) ||
                                      album.xcorredor1.toLowerCase().startsWith(searchController.text.toLowerCase()) ||
                                      album.xcorredor2.toLowerCase().startsWith(searchController.text.toLowerCase()))
                                  .toList();
                              //ordenar desc nro cp
                              // Ordenar la lista según la opción seleccionada
                              if (ordenarPor == 'Numerocp') {
                                filteredAlbums.sort((a, b) => int.parse(a.nroCP)
                                    .compareTo(int.parse(b.nroCP)));
                              } else if (ordenarPor == 'Destino') {
                                filteredAlbums.sort((a, b) {
                                  // Función de comparación personalizada para ordenar por puerto
                                  if (a.xdestino.startsWith('A') &&
                                      !b.xdestino.startsWith('A')) {
                                    return -1; // 'A' viene primero
                                  } else if (!a.xdestino.startsWith('A') &&
                                      b.xdestino.startsWith('A')) {
                                    return 1; // 'A' va después de otros
                                  } else {
                                    return a.xdestino.compareTo(b.xdestino);
                                  }
                                });
                              } else if (ordenarPor == 'Situación') {
                                filteredAlbums.sort((a, b) {
                                  // Función de comparación personalizada para ordenar por situación
                                  return a.nombreSit.compareTo(b.nombreSit);
                                });
                              } else if (ordenarPor == 'TitularDeCp') {
                                filteredAlbums.sort((a, b) {
                                  // Función de comparación personalizada para ordenar por puerto
                                  if (a.xtitular.startsWith('A') &&
                                      !b.xtitular.startsWith('A')) {
                                    return -1; // 'A' viene primero
                                  } else if (!a.xtitular.startsWith('A') &&
                                      b.xtitular.startsWith('A')) {
                                    return 1; // 'A' va después de otros
                                  } else {
                                    return a.xtitular.compareTo(b.xtitular);
                                  }
                                });
                              }
                              return ListView.builder(
                                itemCount: filteredAlbums.length,
                                itemBuilder: (context, index) {
                                  var album = filteredAlbums[index];
                                  var situacion = album.nombreSit;
                                  //print(NroCP);
                                  var rech = situacion.toString();
                                  situacion = situacion.replaceFirst(
                                      situacion[0], situacion[0].toUpperCase());
                                  Map<String, Color> colorMap = {
                                    "RECHAZO": Colors.red,
                                    "CALADO": Colors.green,
                                    "AUTORIZADO":
                                        const Color.fromARGB(255, 3, 1, 126),
                                    "POSICION": Colors.lightBlue,
                                    "DEMORADO": Colors.yellow,
                                    "EN TRANSITO": Colors.pink,
                                    "PROBLEMA EN C.P.": Colors.brown,
                                    "HABLADO PROBLEMA CP":
                                        const Color.fromARGB(255, 176, 39, 96),
                                    "DESCARGADO":
                                        const Color.fromARGB(255, 2, 99, 5),
                                    "SIN CUPO": Colors.green,
                                    "SOLICITA RECHAZO": Colors.purple,
                                    "HABLADO":
                                        const Color.fromARGB(255, 176, 39, 96),
                                    "HABLADO RECHAZO":
                                        const Color.fromARGB(255, 176, 39, 96),
                                    "HABLADO SIN CUPO":
                                        const Color.fromARGB(255, 176, 39, 96),
                                    "DESVIADO": Colors.black
                                  };

                                  Color backgroundColor =
                                      colorMap[rech] ?? Colors.grey;

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 60.0, right: 30, left: 30),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(160, 0, 0, 0),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: backgroundColor,
                                                borderRadius: BorderRadius.circular(
                                                    25), // <- ajustá el valor como quieras
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            35, 10, 5, 10),
                                                    child: Icon(
                                                      (album.idSit == "RCZO")
                                                          ? Icons.cancel
                                                          : (album.idSit ==
                                                                  "AUTO")
                                                              ? Icons.check
                                                              : (album.idSit ==
                                                                      "DEMO")
                                                                  ? Icons
                                                                      .access_time
                                                                  : (album.idSit ==
                                                                          "PECP")
                                                                      ? Icons
                                                                          .change_history
                                                                      : (album.idSit ==
                                                                              "SCUP")
                                                                          ? Icons
                                                                              .stop_circle
                                                                          : (album.idSit == "SRZO")
                                                                              ? Icons.change_history
                                                                              : (album.idSit == "HABL")
                                                                                  ? Icons.check
                                                                                  : (album.idSit == "HRZO")
                                                                                      ? Icons.change_history
                                                                                      : (album.idSit == "HPCP")
                                                                                          ? Icons.change_history
                                                                                          : (album.idSit == "HSCU")
                                                                                              ? Icons.stop_circle
                                                                                              : (album.idSit == "DESC")
                                                                                                  ? Icons.check
                                                                                                  : Icons.change_history,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 10, 0, 10),
                                                    child: Text(
                                                      situacion,
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                40, 10, 0, 10),
                                                    child: Text(
                                                      "TITULAR: ",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0, 10, 0, 0),
                                                      child: Text(
                                                        album.xtitular
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                40, 0, 0, 10),
                                                    child: Text(
                                                      "PROCEDENCIA: ",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      album.nombrePrc
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                40, 0, 0, 10),
                                                    child: Text(
                                                      "NÚMERO CTGE: ",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      album.nroCP.toUpperCase(),
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                40, 0, 0, 10),
                                                    child: Text(
                                                      "DESTINO: ",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      album.xdestino
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                40, 0, 0, 10),
                                                    child: Text(
                                                      "OBSERVACION: ",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      album.observacionesana
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                40, 0, 0, 10),
                                                    child: Text(
                                                      "PATENTE CAMIÓN: ",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      album.chasisFl
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              final String nroCP = album.nroCP;
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await prefs.setString(
                                                  'nroCP', nroCP);
                                              _downLoad(
                                                  username,
                                                  password,
                                                  nroCP,
                                                  fromDate,
                                                  toDate,
                                                  context);
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  40, 0, 0, 10),
                                                      child: Text(
                                                        "IMAGEN: ",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: album.imagen ==
                                                              true
                                                          ? const Icon(
                                                              Icons
                                                                  .image_outlined,
                                                              color:
                                                                  Colors.white,
                                                              size: 25,
                                                            )
                                                          : const Text(
                                                              "Sin imagen",
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 10, 10, 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .end, // Alinea el ícono a la derecha
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.add_circle_outline,
                                                      color: Colors
                                                          .lightBlueAccent),
                                                  iconSize: 40,
                                                  onPressed: () {
                                                    // Acción al presionar el icono +
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AlertDetails(
                                                                album: album),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class OptionWidget extends StatelessWidget {
  final String title;
  final String selectedValue;
  final Function(String) onSelected;

  const OptionWidget({
    Key? key,
    required this.title,
    required this.selectedValue,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          if (title == 'Ordernar por:')
            DropdownButton<String>(
              value: selectedValue, // Establecer el valor seleccionado
              onChanged: (String? value) {
                if (value != null) {
                  // Llama al callback con la opción seleccionada
                  onSelected(value);
                }
              },
              items: ['Seleccionar', 'Numerocp', 'Puerto', 'Situación']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

//IMG
//IMAGEN
void _downLoad(
  String? username,
  String? password,
  String? nroCP,
  String? fromD,
  String? toD,
  BuildContext context,
) async {
  /* print(nroCP);
  print(username);
  print(password); */
  try {
    final regExp = RegExp(r'^(\d{4})-(\d{2})-(\d{2})');
    final fechad = fromD != null ? regExp.firstMatch(fromD) : null;
    final fechah = toD != null ? regExp.firstMatch(toD) : null;

    String fechaFormateadaD = '';
    String fechaFormateadaH = '';
    if (fechad != null) {
      final anio = fechad.group(1);
      final mes = fechad.group(2);
      final dia = fechad.group(3);
      fechaFormateadaD = '$dia/$mes/$anio';
    } else {
      fechaFormateadaD = "";
    }
    if (fechah != null) {
      final anio = fechah.group(1);
      final mes = fechah.group(2);
      final dia = fechah.group(3);
      fechaFormateadaH = '$dia/$mes/$anio';
    } else {
      fechaFormateadaH = "";
    }
    print("siii imagenes");
    final usuario = username;
    final clave = password;
    final nnroCP = nroCP;
    final fromDate = fechaFormateadaD;
    final toDate = fechaFormateadaH;
    //CARGA
    showDialog(
      context: context,
      /* barrierDismissible: false, // evita que se cierre tocando fuera */
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final uri = Uri.parse(
      'http://app.lacostacereales.com.ar/api/Documento/Imagenes?usuario=$usuario&clave=$clave&NroCP=$nnroCP&fechaD=$fromDate&fechaH=$toDate',
    );

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    Navigator.of(context).pop(); // Cierra el diálogo de carga
    print("Status code: ${response.statusCode}");
    print("Body: ${response.body}");

    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> imagenes = jsonResponse['ttImagenes'];

        _showImageDialog(context, imagenes);
      } else {
        print('Error al descargar la imagen');
      }
    } catch (e) {
      print('Error al descargar la imagen: $e');
      // Mostrar un diálogo de error
      Navigator.of(context).pop(); // Cierra el diálogo de carga
    }
  } catch (e) {
    print("Error en _downLoad: $e");
    Navigator.of(context).pop(); // Cierra el diálogo de carga
  }
}

void _showImageDialog(BuildContext context, List<dynamic> imagenes) {
  showDialog(
    context: context,
    builder: (context) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
              TextButton(
                onPressed: () {
                  final List<String> todasLasImagenes = imagenes
                      .map<String>((img) => img['data_CP'].toString())
                      .toList();

                  _shareImages(todasLasImagenes);
                },
                child: const Icon(
                  Icons.share,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
            ],
          ),
          Expanded(
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              itemCount: imagenes.length,
              builder: (context, index) {
                final base64Image = imagenes[index]['data_CP'];
                return PhotoViewGalleryPageOptions(
                  imageProvider: MemoryImage(base64.decode(base64Image)),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  heroAttributes: PhotoViewHeroAttributes(tag: index),
                );
              },
              backgroundDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              pageController: PageController(),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> _shareImages(List<String> base64Images) async {
  try {
    // Obtener el directorio temporal
    Directory tempDir = await getTemporaryDirectory();

    // Lista de rutas de archivos temporales
    List<String> tempFilePaths = [];

    for (int i = 0; i < base64Images.length; i++) {
      Uint8List bytes = base64.decode(base64Images[i]);
      String tempFilePath = '${tempDir.path}/temp_image_$i.png';

      File tempFile = File(tempFilePath);
      await tempFile.writeAsBytes(bytes);

      tempFilePaths.add(tempFilePath);
    }

    // Compartir todos los archivos
    await Share.shareFiles(tempFilePaths);
  } catch (e) {
    print('Error al compartir las imágenes: $e');
  }
}
