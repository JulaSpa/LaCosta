import 'package:flutter/material.dart';
import 'package:la_costa_cereales/album/album.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:la_costa_cereales/pages/detalles.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Alertas extends StatefulWidget {
  const Alertas({super.key});

  @override
  State<Alertas> createState() => _AlertasState();
}

class _AlertasState extends State<Alertas> {
  String? username;
  String? password;
  late Future<List<Album>> futureAlbum;
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
    });
    _loadAlbumData(); // Llama a la función para cargar los datos del álbum.
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
    final posicion = decoded['ttDocumento'];
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
              image: AssetImage("lib/images/fondo_la_costa.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
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
            elevation: 0,
            centerTitle: true,
            toolbarHeight: 120,
            iconTheme: const IconThemeData(color: Colors.white),
            automaticallyImplyLeading: true,
            actions: [
              GestureDetector(
                onTap: () {
                  // Toggle the visibility of options
                  setState(() {
                    isOptionsVisible = !isOptionsVisible;
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.search),
                ),
              ),
            ],
          ),
          body: DecoratedBox(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(117, 0, 0, 0)),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(children: [
                      // Opción "Buscar por palabra clave"
                      Column(
                        children: [
                          if (isOptionsVisible)
                            ListTile(
                              title: TextField(
                                controller: searchController,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Buscar por palabra clave',
                                  hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
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
                                                      "NÚMERO CP: ",
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
                                              print(
                                                  'Click detectado, llamando _downLoad...');
                                              _downLoad(username, password,
                                                  nroCP, context);
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
                                                    Expanded(
                                                      child: Text(
                                                        album.imagen == true
                                                            ? "Link"
                                                            : "Link",
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
                    ])),
        ),
      ],
    );
  }
}

//ORDENAR
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
          Text(
            title,
            style: const TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
            ),
          ),
          if (title == 'Ordernar por:')
            DropdownButton<String>(
              value: selectedValue, // Establecer el valor seleccionado
              onChanged: (String? value) {
                if (value != null) {
                  // Llama al callback con la opción seleccionada
                  onSelected(value);
                }
              },
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              items: [
                'Seleccionar',
                'Numerocp',
                'Puerto',
                'Situación',
                "TitularDeCp"
              ]
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
  BuildContext context,
) async {
  /* print(nroCP);
  print(username);
  print(password); */
  try {
    print("siii imagenes");
    final usuario = username;
    final clave = password;
    final nnroCP = nroCP;

    final uri = Uri.parse(
      'http://app.lacostacereales.com.ar/api/Documento/Imagenes?usuario=$usuario&clave=$clave&NroCP=$nnroCP&fechaD=16/5/25&fechaH=16/5/25',
    );

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print("Status code: ${response.statusCode}");
    print("Body: ${response.body}");

    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> imagenes = jsonResponse['ttImagenes'];

        final base64Image = imagenes[0]['data_CP'];

        _showImageDialog(context, base64Image);
      } else {
        print('Error al descargar la imagen');
      }
    } catch (e) {
      print('Error al descargar la imagen: $e');
      // Mostrar un diálogo de error
    }
  } catch (e) {
    print("Error en _downLoad: $e");
  }
}

void _showImageDialog(BuildContext context, String base64Image) {
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
                  _shareImage(base64Image);
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
              itemCount: 1,
              builder: (context, index) {
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

Future<void> _shareImage(String base64Image) async {
  try {
    // Decodificar la cadena base64 en bytes
    Uint8List bytes = base64.decode(base64Image);

    // Obtener un directorio temporal para guardar el archivo
    Directory tempDir = await getTemporaryDirectory();
    String tempFilePath = '${tempDir.path}/temp_image.png';

    // Guardar los bytes en un archivo temporal
    File tempFile = File(tempFilePath);
    await tempFile.writeAsBytes(bytes);

    // Compartir el archivo
    await Share.shareFiles([tempFilePath]);
  } catch (e) {
    print('Error al compartir la imagen: $e');
  }
}
