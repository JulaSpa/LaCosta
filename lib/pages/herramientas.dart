import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              insetPadding:
                                  EdgeInsets.zero, // pantalla completa
                              backgroundColor:
                                  const Color.fromARGB(75, 0, 0, 0),
                              child: Stack(
                                children: [
                                  PhotoViewGallery.builder(
                                    itemCount: 1, // número de imágenes
                                    builder: (context, index) {
                                      return PhotoViewGalleryPageOptions(
                                        imageProvider: const NetworkImage(
                                          'http://www.lacostacereales.com.ar/assets/images/gastos-1-1066x642.png',
                                        ),
                                        minScale:
                                            PhotoViewComputedScale.contained,
                                        maxScale:
                                            PhotoViewComputedScale.covered * 3,
                                        heroAttributes:
                                            const PhotoViewHeroAttributes(
                                                tag: "gastos-img"),
                                      );
                                    },
                                    scrollPhysics:
                                        const BouncingScrollPhysics(),
                                    backgroundDecoration: const BoxDecoration(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Positioned(
                                    top: 40,
                                    right: 20,
                                    child: IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.white),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        splashColor: Colors.white24,
                        highlightColor: Colors.white10,
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: 62.0,
                            right: 62.0,
                            top: 20.0,
                            bottom: 20.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.engineering_outlined,
                                color: Colors.white,
                                size: 60,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  "Gastos de secada",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
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
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              insetPadding:
                                  EdgeInsets.zero, // pantalla completa
                              backgroundColor:
                                  const Color.fromARGB(75, 0, 0, 0),
                              child: Stack(
                                children: [
                                  PhotoViewGallery.builder(
                                    itemCount: 1, // número de imágenes
                                    builder: (context, index) {
                                      return PhotoViewGalleryPageOptions(
                                        imageProvider: const NetworkImage(
                                          'http://www.lacostacereales.com.ar/assets/images/tipos-de-camiones-que-reciben-las-plantas-974x1316.png',
                                        ),
                                        minScale:
                                            PhotoViewComputedScale.contained,
                                        maxScale:
                                            PhotoViewComputedScale.covered * 3,
                                        heroAttributes:
                                            const PhotoViewHeroAttributes(
                                                tag: "gastos-img"),
                                      );
                                    },
                                    scrollPhysics:
                                        const BouncingScrollPhysics(),
                                    backgroundDecoration: const BoxDecoration(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Positioned(
                                    top: 40,
                                    right: 20,
                                    child: IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.white),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        splashColor: Colors.white24,
                        highlightColor: Colors.white10,
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: 62.0,
                            right: 62.0,
                            top: 20.0,
                            bottom: 20.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.car_crash_outlined,
                                color: Colors.white,
                                size: 60,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  "Tipos de camiones admitidos en puertos",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
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
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              insetPadding:
                                  EdgeInsets.zero, // pantalla completa
                              backgroundColor:
                                  const Color.fromARGB(75, 0, 0, 0),
                              child: Stack(
                                children: [
                                  PhotoViewGallery.builder(
                                    itemCount: 1, // número de imágenes
                                    builder: (context, index) {
                                      return PhotoViewGalleryPageOptions(
                                        imageProvider: const NetworkImage(
                                          'http://lacostacereales.com.ar/assets/images/acondiciona-1400x774.png',
                                        ),
                                        minScale:
                                            PhotoViewComputedScale.contained,
                                        maxScale:
                                            PhotoViewComputedScale.covered * 3,
                                        heroAttributes:
                                            const PhotoViewHeroAttributes(
                                                tag: "gastos-img"),
                                      );
                                    },
                                    scrollPhysics:
                                        const BouncingScrollPhysics(),
                                    backgroundDecoration: const BoxDecoration(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Positioned(
                                    top: 40,
                                    right: 20,
                                    child: IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.white),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        splashColor: Colors.white24,
                        highlightColor: Colors.white10,
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: 62.0,
                            right: 62.0,
                            top: 20.0,
                            bottom: 20.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.money_rounded,
                                color: Colors.white,
                                size: 60,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  "Tarifa de acondicionadoras",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
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
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              insetPadding:
                                  EdgeInsets.zero, // pantalla completa
                              backgroundColor:
                                  const Color.fromARGB(75, 0, 0, 0),
                              child: Stack(
                                children: [
                                  PhotoViewGallery.builder(
                                    itemCount: 1, // número de imágenes
                                    builder: (context, index) {
                                      return PhotoViewGalleryPageOptions(
                                        imageProvider: const NetworkImage(
                                          'http://www.lacostacereales.com.ar/assets/images/plantas2-1079x2679.png',
                                        ),
                                        minScale:
                                            PhotoViewComputedScale.contained,
                                        maxScale:
                                            PhotoViewComputedScale.covered * 3,
                                        heroAttributes:
                                            const PhotoViewHeroAttributes(
                                                tag: "gastos-img"),
                                      );
                                    },
                                    scrollPhysics:
                                        const BouncingScrollPhysics(),
                                    backgroundDecoration: const BoxDecoration(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Positioned(
                                    top: 40,
                                    right: 20,
                                    child: IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.white),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        splashColor: Colors.white24,
                        highlightColor: Colors.white10,
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: 62.0,
                            right: 62.0,
                            top: 20.0,
                            bottom: 20.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.book_online,
                                color: Colors.white,
                                size: 60,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  "Códigos en puertos y plantas",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
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
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              insetPadding:
                                  EdgeInsets.zero, // pantalla completa
                              backgroundColor:
                                  const Color.fromARGB(75, 0, 0, 0),
                              child: Stack(
                                children: [
                                  PhotoViewGallery.builder(
                                    itemCount: 1, // número de imágenes
                                    builder: (context, index) {
                                      return PhotoViewGalleryPageOptions(
                                        imageProvider: const NetworkImage(
                                          'http://www.lacostacereales.com.ar/assets/images/tolerancia-blnz-627x326.png',
                                        ),
                                        minScale:
                                            PhotoViewComputedScale.contained,
                                        maxScale:
                                            PhotoViewComputedScale.covered * 3,
                                        heroAttributes:
                                            const PhotoViewHeroAttributes(
                                                tag: "gastos-img"),
                                      );
                                    },
                                    scrollPhysics:
                                        const BouncingScrollPhysics(),
                                    backgroundDecoration: const BoxDecoration(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Positioned(
                                    top: 40,
                                    right: 20,
                                    child: IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.white),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        splashColor: Colors.white24,
                        highlightColor: Colors.white10,
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: 62.0,
                            right: 62.0,
                            top: 20.0,
                            bottom: 20.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.line_weight,
                                color: Colors.white,
                                size: 60,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  "Tolerancia en balanzas",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
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
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              insetPadding:
                                  EdgeInsets.zero, // pantalla completa
                              backgroundColor:
                                  const Color.fromARGB(75, 0, 0, 0),
                              child: Stack(
                                children: [
                                  PhotoViewGallery.builder(
                                    itemCount: 1, // número de imágenes
                                    builder: (context, index) {
                                      return PhotoViewGalleryPageOptions(
                                        imageProvider: const NetworkImage(
                                          'http://www.lacostacereales.com.ar/assets/images/cupo-1400x665.png',
                                        ),
                                        minScale:
                                            PhotoViewComputedScale.contained,
                                        maxScale:
                                            PhotoViewComputedScale.covered * 3,
                                        heroAttributes:
                                            const PhotoViewHeroAttributes(
                                                tag: "gastos-img"),
                                      );
                                    },
                                    scrollPhysics:
                                        const BouncingScrollPhysics(),
                                    backgroundDecoration: const BoxDecoration(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Positioned(
                                    top: 40,
                                    right: 20,
                                    child: IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.white),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        splashColor: Colors.white24,
                        highlightColor: Colors.white10,
                        child: const Padding(
                          padding: EdgeInsets.only(
                            left: 62.0,
                            right: 62.0,
                            top: 20.0,
                            bottom: 20.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                                size: 60,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  "Horarios de cupos",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
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
