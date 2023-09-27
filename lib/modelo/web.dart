import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:beautiful_soup_dart/beautiful_soup.dart';

// import 'dart:io';

// Define la URL del QR
Future<void> probar() async {
  String qr_url = 'https://serviciosweb.afip.gob.ar/clavefiscal/qr/response.aspx?qr=7gbG0UVlv3codO6nHiw1iA,,';

// Hace una solicitud HTTP a la URL del QR y obtiene el código HTML de la página web
  final response = await http.get(Uri.parse(qr_url));
  String html = response.body;

  // Crea un objeto BeautifulSoup para analizar el código HTML
  var soup = BeautifulSoup(html);

  // Busca el elemento que contiene el CUIT del emisor
  var cuit_element = soup.find('input', id: 'tbCUIT');

  // Extrae el texto del elemento y lo guarda en una variable
  print(cuit_element);
  String cuit = cuit_element!.attributes['value']!;

  // Busca el elemento que contiene la denominación del emisor
  var denominacion_element = soup.find('textarea', id: 'taDenominacion');
  print(denominacion_element);

  // Extrae el texto del elemento y lo guarda en otra variable
  String denominacion = denominacion_element!.text;

  // Imprime los datos extraídos
  print('CUIT: $cuit');
  print('Denominación: $denominacion');
  ;
}

averiguarCuit() async {
// Define la URL del QR
  String qrUrl = 'https://serviciosweb.afip.gob.ar/clavefiscal/qr/response.aspx?qr=7gbG0UVlv3codO6nHiw1iA,,';

// Hace una solicitud HTTP a la URL del QR y obtiene el código HTML de la página web
  http.Response response = await http.get(Uri.parse(qrUrl));
  String htmlCode = response.body;
  print(htmlCode);
// Crea un objeto html.Document para analizar el código HTML
  final document = html.parse(htmlCode);

// Busca el elemento que contiene el CUIT del emisor
  final cuitElement = document.querySelector('input#tbCUIT');

// Extrae el texto del elemento y lo guarda en una variable
  print(cuitElement);
  final cuit = cuitElement!.attributes['value'];

// Busca el elemento que contiene la denominación del emisor
  final denominacionElement = document.querySelector('textarea#taDenominacion');
  print(denominacionElement);

// Extrae el texto del elemento y lo guarda en otra variable
  String denominacion = denominacionElement!.text;

// Imprime los datos extraídos
  print('CUIT: $cuit');
  print('Denominación: $denominacion');
}

Future<String> traerCuit(String cuit) async {
  final url = Uri.parse("https://servicioscf.afip.gob.ar/publico/denuncias/denunciaCD.aspx/BuscarCUIT");

  final headers = {
    "accept": "application/json, text/javascript, */*; q=0.01",
    "accept-language": "es-ES,es;q=0.9",
    "content-type": "application/json; charset=UTF-8",
    "sec-ch-ua": "\"Google Chrome\";v=\"117\", \"Not;A=Brand\";v=\"8\", \"Chromium\";v=\"117\"",
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "\"Windows\"",
    "sec-fetch-dest": "empty",
    "sec-fetch-mode": "cors",
    "sec-fetch-site": "same-origin",
    "x-requested-with": "XMLHttpRequest",
  };

  final data = {"CUIT": cuit};

  final response = await http.post(
    url,
    headers: headers,
    body: json.encode(data),
  );

  if (response.statusCode == 200) {
    print("Response: ${response.body}");
    return response.body;
  } else {
    print("Request failed with status: ${response.statusCode}");
    return "** ERROR **";
  }
}

traer2() async {
  final response = await http.get(
    Uri.parse("https://serviciosweb.afip.gob.ar/clavefiscal/qr/response.aspx?qr=7gbG0UVlv3codO6nHiw1iA,,"),
    headers: {
      "accept":
          "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
      "accept-language": "es-ES,es;q=0.9",
      "sec-ch-ua": "\"Google Chrome\";v=\"117\", \"Not;A=Brand\";v=\"8\", \"Chromium\";v=\"117\"",
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": "\"Windows\"",
      "sec-fetch-dest": "document",
      "sec-fetch-mode": "navigate",
      "sec-fetch-site": "none",
      "sec-fetch-user": "?1",
      "upgrade-insecure-requests": "1"
    },
  );

  print("HEADERS ${response.statusCode} > ${response.headers.length}");
  for (final k in response.headers.keys) {
    print("| $k: ${response.headers[k]}");
  }
  if (response.statusCode == 200) {
    // print("Response: ${response.body}");
  } else {
    print("Request failed with status: ${response.statusCode}");
  }
}

void traer1() async {
  final url1 = 'http://qr.afip.gob.ar/?qr=7gbG0UVlv3codO6nHiw1iA,,';
  final url2 = 'https://serviciosweb.afip.gob.ar/clavefiscal/qr/response.aspx?qr=7gbG0UVlv3codO6nHiw1iA,,';
  final url3 = "https://servicioscf.afip.gob.ar/publico/denuncias/denunciaCD.aspx/BuscarCUIT";

  // final url = Uri.parse(url3);

  // final headers = {
  //   "Accept": "application/json, text/javascript, */*; q=0.01",
  //   "Content-Type": "application/json; charset=UTF-8",
  // };

  // final data = {"CUIT": "33501576269"};

  final url = Uri.parse(url2);

  final response = await http.get(
    url,
    // headers: headers,
    // body: json.encode(data),
  );

  print("statusCode= ${response.statusCode}");
  if (response.statusCode == 200) {
    // print("Response: ${response.body}");
  } else {
    print("Request failed with status: ${response.statusCode}");
  }
}

void main() async {
  // await traer2();
  // await averiguarCuit();
  await probar();
}
