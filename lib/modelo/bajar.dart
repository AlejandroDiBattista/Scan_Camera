import 'package:http/http.dart' as http;

const afip = 'serviciosweb.afip.gob.ar';
const url2 = 'https://serviciosweb.afip.gob.ar/clavefiscal/qr/response.aspx?qr=7gbG0UVlv3codO6nHiw1iA,,';
const qr = '7gbG0UVlv3codO6nHiw1iA,,';
const cuit = '33501576269';

void mostrar(Map<String, String> variables) {
  print("    Hay ${variables.length} entradas");
  for (final k in variables.keys) {
    String v = variables[k] ?? "";
    if (v.length > 150) v = v.substring(0, 150);
    print('    ◾ ${k.padRight(20)}: ${v}');
  }
}

void main() async {
  final client = http.Client();
  const urlAfip = 'serviciosweb.afip.gob.ar';
  print("\n⭕ BAJAR QR $urlAfip\n");
  var url = Uri.https(urlAfip, '/clavefiscal/qr/response.aspx', {'qr': '7gbG0UVlv3codO6nHiw1iA,,'});

  var response = await client.get(url);
  var location = response.headers["location"] ?? "";

  print('''

🔹 URL: $url
    status   : ${response.statusCode} 
    location : $location 
    ''');
  mostrar(response.headers);

  url = Uri.parse(location);
  response = await client.get(url);
  location = response.headers["location"] ?? "";

  print('''

🔹 URL: $url
    status   : ${response.statusCode} 
    location : $location 
    ''');
  mostrar(response.headers);

  url = Uri.https(urlAfip, location);
  // response = await client.post(url, headers: {'cookie': cookie});
  response = await client.post(url);
  location = response.headers["location"] ?? "";

  print('''

🔹 URL: $url
    status   : ${response.statusCode} 
    location : $location 
    ''');
  mostrar(response.headers);

  print(response.body);
}
