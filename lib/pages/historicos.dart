import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchArguments {
  final DateTime? fromDate;
  final DateTime? toDate;

  SearchArguments({this.fromDate, this.toDate});
}

class Historic extends StatefulWidget {
  const Historic({super.key});

  @override
  State<Historic> createState() => _HistoricState();
}

class _HistoricState extends State<Historic> {
  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;
  var nroCP = TextEditingController();
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
            iconTheme: const IconThemeData(color: Colors.white),

            toolbarHeight: 120,
          ),
          body: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    // Campo "desde"
                    Container(
                      padding: const EdgeInsets.only(top: 80),
                      child: FractionallySizedBox(
                        widthFactor: 0.7,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(
                                30), // Ajusta el valor según lo curvo que quieras
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _selectFromDate(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Text(
                                        _selectedFromDate != null
                                            ? 'Desde: ${DateFormat('dd/MM/y').format(_selectedFromDate!)}'
                                            : 'Desde: dd/mm/a',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.calendar_month,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Campo "hasta"
                    Container(
                      padding: const EdgeInsets.only(top: 40),
                      constraints: const BoxConstraints(
                        minWidth:
                            1000, // Ajusta la altura mínima según tus necesidades
                      ),
                      child: FractionallySizedBox(
                        widthFactor: 0.7,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(
                                30), // Ajusta el valor según lo curvo que quieras
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _selectToDate(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Text(
                                        _selectedToDate != null
                                            ? 'Hasta: ${DateFormat('dd/MM/y').format(_selectedToDate!)}'
                                            : 'Hasta: dd/mm/a',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.calendar_month,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: FractionallySizedBox(
                        widthFactor: 0.7,
                        child: TextField(
                          style: const TextStyle(color: Colors.white),

                          decoration: const InputDecoration(
                            labelText: "Número CP",
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 252, 250, 250),
                                fontSize: 15),
                            contentPadding: EdgeInsets.only(left: 20),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255),
                                width: 1,
                              ),
                            ),
                          ),
                          //CONTROLADOR CP
                          controller: nroCP,
                        ),
                      ),
                    ),
                    //BUSCAR

                    Container(
                      constraints:
                          const BoxConstraints(maxWidth: 400, minWidth: 100),
                      child: FractionallySizedBox(
                        widthFactor: 0.3,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 253, 110, 15),
                              borderRadius: BorderRadius.circular(20)),
                          child: ListTile(
                            title: const Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // centra ícono y texto
                              children: [
                                Icon(Icons.search, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Buscar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            onTap: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final String cpBuscarPage = nroCP.text;
                              await prefs.setString(
                                  'cpBuscarPage', cpBuscarPage);

                              if (_selectedFromDate != null &&
                                  _selectedToDate != null) {
                                await prefs.setString('fromDate',
                                    _selectedFromDate!.toIso8601String());
                                await prefs.setString('toDate',
                                    _selectedToDate!.toIso8601String());
                              } else {
                                // Si las fechas no están seleccionadas, borra las entradas de SharedPreferences
                                await prefs.remove('fromDate');
                                await prefs.remove('toDate');
                              }

                              // Usa el contexto almacenado dentro del contexto asíncrono
                              Future.microtask(() {
                                Navigator.pushNamed(context, "/buscar");
                              });
                            },
                          ),
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
    );
  }

  // Funciones para mostrar los calendarios para seleccionar las fechas
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedFromDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedFromDate) {
      setState(() {
        _selectedFromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedToDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedToDate) {
      setState(() {
        _selectedToDate = picked;
      });
    }
  }
}
