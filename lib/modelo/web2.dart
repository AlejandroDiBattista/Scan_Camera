import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

Future<void> main() async {
  // Define la URL del QR
  final qrUrl = 'https://serviciosweb.afip.gob.ar/clavefiscal/qr/response.aspx?qr=7gbG0UVlv3codO6nHiw1iA,,';

  // Realiza una solicitud HTTP inicial a la URL del QR
  var response = await http.post(Uri.parse(qrUrl));

  print(" Redirect: ${response.statusCode}");

  while (response.statusCode >= 300 && response.statusCode < 400) {
    print(" Redirect: ${response.statusCode}");
    // La respuesta es un redireccionamiento
    final redirectUrl = response.headers['location'];
    if (redirectUrl != null) {
      response = await http.get(Uri.parse(redirectUrl));
    }
  }

  // La respuesta es exitosa (código 200)
  final html = response.body;
  print(html);
  // Continúa el procesamiento del HTML aquí
  final document = parse(html);

  // Busca el elemento que contiene el CUIT del emisor
  final cuitElement = document.querySelector('#tbCUIT');

  // Extrae el texto del elemento y lo guarda en una variable
  final cuit = cuitElement?.attributes['value'] ?? "X";

  // Busca el elemento que contiene la denominación del emisor
  final denominacionElement = document.querySelector('#taDenominacion');

  // Extrae el texto del elemento y lo guarda en otra variable
  final denominacion = denominacionElement?.text ?? "Y";

  // Imprime los datos extraídos
  print('CUIT: $cuit');
  print('Denominación: $denominacion');
}
