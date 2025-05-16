class Album {
  final String nroCP;
  final String nombreSit;
  final String xtitular;
  final String nombrePrc;
  final String xintermediario;
  final String xcorredor;
  final String observacionesana;
  final String xdestinatario;
  final String xdestino;
  final String idFl;

  final bool imagen;
  final String chofer;
  final String chasisFl;

  final String idSit;
  final String rem2;
  final String remCom;
  final String rem1;
  final String rem3;
  final String xcorredor1;
  final String xcorredor2;
  final String kg;

  const Album({
    required this.nroCP,
    required this.nombreSit,
    required this.xtitular,
    required this.nombrePrc,
    required this.xintermediario,
    required this.xcorredor,
    required this.observacionesana,
    required this.xdestinatario,
    required this.xdestino,
    required this.idFl,
    required this.imagen,
    required this.chofer,
    required this.chasisFl,
    required this.idSit,
    required this.rem2,
    required this.remCom,
    required this.rem1,
    required this.rem3,
    required this.xcorredor1,
    required this.xcorredor2,
    required this.kg,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      nroCP: json['nro_cp'] ?? '',
      nombreSit: json['situacion'] ?? '',
      xtitular: json['titular'] ?? '',
      nombrePrc: json['procedencia'] ?? '',
      xintermediario: json["intermediario"] ?? '',
      xcorredor: json["corredorComp"] ?? '',
      observacionesana: json["observacionesAna"] ?? '',
      xdestinatario: json["destinatario"] ?? '',
      xdestino: json["destino"] ?? '',
      idFl: json["idFl"] ?? '',
      imagen: json["imagen"] ?? '',
      chofer: json["chofer"] ?? '',
      chasisFl: json["chasis"] ?? '',
      idSit: json["idSit"] ?? '',
      rem2: json["remitente2"] ?? '',
      remCom: json["comercial"] ?? '',
      rem1: json["remitente1"] ?? '',
      rem3: json["remitente3"] ?? '',
      xcorredor1: json["corredorComp"] ?? '',
      xcorredor2: json["corredorVend"] ?? '',
      kg: json["taraPro"] ?? '',
    );
  }
}
