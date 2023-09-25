import 'package:web_scraper/web_scraper.dart';

class Cliente {
  String cuit;
  String nombre;
  String domicilio;

  Cliente(this.cuit, this.nombre, this.domicilio);

  @override
  String toString() => 'Cliente($cuit, $nombre, $domicilio)';

  static Future<Cliente?> cargar(String url) async {
    // http://qr.afip.gob.ar/?qr=7gbG0UVlv3codO6nHiw1iA,,
    if (!url.startsWith('http://qr.afip.gob.ar')) return null;

    print('Bajando [$url]');

    final webScraper = WebScraper('http://qr.afip.gob.ar');
    if (await webScraper.loadWebPage(url.replaceFirst('http://qr.afip.gob.ar', ''))) {
      final inputCuit = webScraper.getElement('input#tbCUIT', ['value']);
      final textareaDenominacion = webScraper.getElement('textarea#taDenominacion', []);
      final selectDomicilios = webScraper.getElement('select#ddlDomicilios > option[selected]', []);

      final cuit = inputCuit[0]['attributes']['value'] ?? '';
      final denominacion = textareaDenominacion[0]['title'] ?? '';
      final domicilio = selectDomicilios[0]['title'] ?? '';
      return Cliente(cuit, denominacion, domicilio);
    } else {
      return null;
    }
  }
}
