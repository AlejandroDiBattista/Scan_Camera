import 'package:http/http.dart' as http;

const afip = 'serviciosweb.afip.gob.ar';
const url2 = 'https://serviciosweb.afip.gob.ar/clavefiscal/qr/response.aspx?qr=7gbG0UVlv3codO6nHiw1iA,,';
const qr = '7gbG0UVlv3codO6nHiw1iA,,';
const cuit = '33501576269';

void mostrar(Map<String, String> variables) {
  print("\nHay ${variables.length} entradas");
  for (final k in variables.keys) {
    String v = variables[k] ?? "";
    if (v.length > 150) v = v.substring(0, 150);
    print('◾ ${k.padRight(20)}: ${v}');
  }
}

void main() async {
  print("> BAJAR QR\n");
  const urlAfip = 'serviciosweb.afip.gob.ar';
  var url = Uri.https(urlAfip, '/clavefiscal/qr/response.aspx', {'qr': '7gbG0UVlv3codO6nHiw1iA,,'});

  var response = await http.post(url);
  var location = response.headers["location"] ?? "";
  var cookie = response.headers["set-cookie"] ?? "";
  var parametro = location.split("?")[1];

  print("\n\nURL: $url");
  print(
      '\tResponse status: ${response.statusCode} \n\tlocation : $location \n\tparametro: $parametro \n\t: $cookie');
  mostrar(response.headers);

  url = Uri.parse(location);
  response = await http.get(url, headers: {'cookie': cookie});
  location = response.headers["location"] ?? "";
  cookie = response.headers["set-cookie"] ?? "";

  print("\n\nURL: $url");
  print('\tResponse status: ${response.statusCode} \n\tlocation: $location');
  mostrar(response.headers);

  url = Uri.https(urlAfip, location);
  response = await http.post(url, headers: {'cookie': cookie});
  location = response.headers["location"] ?? "";

  print("\n\nURL: $url");
  print('\tResponse status: ${response.statusCode} \n\tlocation: $location');
  mostrar(response.headers);

  print(response.body);
}
