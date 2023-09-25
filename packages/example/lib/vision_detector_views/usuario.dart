class Usuario {
  String dni;
  String nombre;
  String apellido;
  String sexo;
  DateTime nacimiento;

  Usuario(this.dni, this.nombre, this.apellido, this.sexo, this.nacimiento);

  static Usuario? cargar(String codigo) {
    final RegExp exp = RegExp(
        r'^(\d{11})@([A-Z\s]+)@([A-Z\s]+)@([MF])@(\d{8})@([A-Z])@(\d{2}/\d{2}/\d{4})@(\d{2}/\d{2}/\d{4})@(\d{3})$');

    if (!exp.hasMatch(codigo)) return null;

    final RegExpMatch match = exp.firstMatch(codigo)!;
    final dni = match.group(5)!;
    final nombre = match.group(3)!;
    final apellido = match.group(2)!;
    final sexo = match.group(4)!;
    final nacimiento = match.group(7)!;
    final fecha = nacimiento.split('/').reversed.join('-');
    return Usuario(dni, nombre, apellido, sexo, DateTime.parse(fecha));
  }

  @override
  String toString() => 'Usuario: $apellido, $nombre > $dni';
}
