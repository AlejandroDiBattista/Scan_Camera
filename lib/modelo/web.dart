import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:beautiful_soup_dart/beautiful_soup.dart';

// import 'dart:io';

const url1 = 'http://qr.afip.gob.ar/?qr=7gbG0UVlv3codO6nHiw1iA,,';
const url2 = 'https://serviciosweb.afip.gob.ar/clavefiscal/qr/response.aspx?qr=7gbG0UVlv3codO6nHiw1iA,,';
const url3 = "https://servicioscf.afip.gob.ar/publico/denuncias/denunciaCD.aspx/BuscarCUIT";
const cuit = '33501576269';

Future<void> traerBS() async {
  print("\n traerBS \n");
  String url = url2;

  final response = await http.get(Uri.parse(url));
  String html = response.body;

  var soup = BeautifulSoup(html);
  var cuit_element = soup.find('input', id: 'tbCUIT');
  print(cuit_element);

  String cuit = cuit_element!.attributes['value']!;
  var denominacion_element = soup.find('textarea', id: 'taDenominacion');
  print(denominacion_element);

  String denominacion = denominacion_element!.text;
  print('CUIT         : $cuit');
  print('Denominación : $denominacion');
}

Future<void> traerHttp() async {
  print("\n traerHttp \n");
  String url = url2;

  http.Response response = await http.get(Uri.parse(url));
  String htmlCode = response.body;
  // print(htmlCode);

  final document = html.parse(htmlCode);
  final cuitElement = document.querySelector('input#tbCUIT');

  print(cuitElement);
  final cuit = cuitElement!.attributes['value'];

  final denominacionElement = document.querySelector('textarea#taDenominacion');
  print(denominacionElement);

  String denominacion = denominacionElement!.text;

  print('CUIT: $cuit');
  print('Denominación: $denominacion');
}

Future<void> traerCuit(String cuit) async {
  print("\n traerCuit \n");

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

  final response = await http.post(url, headers: headers, body: json.encode(data));

  if (response.statusCode == 200) {
    // print("Response: ${response.body}");
  } else {
    print("Request failed with status: ${response.statusCode}");
  }
}

Future<void> traerHttp2() async {
  print("\n traerHttp \n");

  final response = await http.get(
    Uri.parse(url2),
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

Future<void> traerHttp1() async {
    print("\n traerHttp1 \n");

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
  await traerBS();
  // await traerCuit(cuit);
  // await traerHttp();
  // await traerHttp1();
  // await traerHttp2();
}
