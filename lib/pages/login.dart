import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({
    super.key,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var myController = TextEditingController();
  var pass = TextEditingController();
  bool logInOut = false;
  //recordar usuario y contraseña
  bool isChecked = false;
  String? username;
  String? password;
  @override
  void initState() {
    super.initState();
    _getStoredUserData();
  }

  Future<void> _getStoredUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    final storedPassword = prefs.getString('password');

    setState(() {
      isChecked = prefs.getBool("rememberUserData") ?? false;
      username = storedUsername;
      password = storedPassword;
      if (isChecked) {
        myController.text = prefs.getString("username") ?? '';
        pass.text = prefs.getString("password") ?? "";
      } else {
        myController.text = "";
        pass.text = "";
      }
    });
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
          automaticallyImplyLeading: false, // Desactivamos el automático

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
        body: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: FractionallySizedBox(
            widthFactor: 1,
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(20),
                constraints: BoxConstraints(maxWidth: 1000),
                decoration: BoxDecoration(
                  color: Color.fromARGB(117, 68, 68, 68), // Fondo tipo tarjeta
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 60),
                      child: const Text(
                        "ACCESO",
                        style: TextStyle(
                            color: Color.fromARGB(255, 252, 250, 250),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 1000),
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Color.fromARGB(221, 73, 31, 3),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            prefixIcon: Icon(
                              Icons.account_circle_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                            labelText: "Nombre de usuario",
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 252, 250, 250),
                                fontSize: 13),
                          ),
                          //CONTROLADOR USUARIO
                          controller: myController,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      constraints: BoxConstraints(maxWidth: 1000),
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: const InputDecoration(
                            isDense: true,
                            filled: true, //activa el fondo
                            fillColor: Color.fromARGB(221, 73, 31, 3),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                            labelText: "Contraseña",
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 252, 250, 250),
                                fontSize: 13),
                          ),
                          //CONTROLADOR CONTRASEÑA
                          controller: pass,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      constraints: BoxConstraints(maxWidth: 1000),
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: CheckboxListTile(
                          side: const BorderSide(color: Colors.white),
                          title: const Text(
                            "Recordar usuario y contraseña",
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                          value: isChecked,
                          activeColor: Color.fromARGB(255, 253, 110, 15),
                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onChanged: (bool? value) async {
                            final prefs = await SharedPreferences.getInstance();
                            setState(() {
                              isChecked = value!;
                              prefs.setBool("rememberUserData",
                                  isChecked); // Guarda el estado del checkbox en SharedPreferences
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 40, bottom: 15),
                      constraints: BoxConstraints(maxWidth: 400),
                      child: FractionallySizedBox(
                        widthFactor: 0.5,
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(
                                  221, 73, 31, 3), // fondo blanco
                              foregroundColor: Color.fromARGB(
                                  255, 255, 255, 255), // texto negro
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // bordes redondeados
                              ),
                            ),
                            onPressed: () async {
                              final String username = myController.text;
                              final String password = pass.text;
                              // Guardar en SharedPreferences
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString('username', username);
                              await prefs.setString('password', password);
                              await prefs.setBool('logInOut', true);

                              // Actualiza los valores antes de enviar la solicitud
                              setState(() {
                                this.username = username;
                                this.password = password;
                              });
                              print(username);
                              print(password);
                              // Carga los datos del álbum
                              /* _loadAlbumData(); */
                              Navigator.pushNamed(
                                context,
                                "/home",
                              );
                            },
                            child: const Text("Ingresar"),
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
      ),
    ]);
  }
}
