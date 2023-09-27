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
    final a = 'http://qr.afip.gob.ar';
    final b = '?qr=7gbG0UVlv3codO6nHiw1iA,,';

    // final webScraper = WebScraper('http://qr.afip.gob.ar');
    final webScraper = WebScraper(a);
    // if (await webScraper.loadWebPage(url.replaceFirst('http://qr.afip.gob.ar', ''))) {
    print("Ya conecté la pagina");
    final wp = await webScraper.loadWebPage(b);
    print("Ya bajé la página");

    if (wp) {
      final t = webScraper.getPageContent();
      print("Estoy buscando > ${t.length} > ${t.contains("33501576269")}");
      print("Estoy buscando > ${t.length} > ${t.contains("Sin guiones ni espacios")}");
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

void main() async {
  try {
    final u = await Cliente.cargar("http://qr.afip.gob.ar/?qr=7gbG0UVlv3codO6nHiw1iA,,");
    print("$u");
  } catch (e) {
    print("Error: $e");
  }
}
