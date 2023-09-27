import 'dart:convert';

class Cliente {
  int cuenta;
  String dni;
  String apellido;
  String nombre;
  String telefono;
  DateTime nacimiento;
  String sexo;

  Cliente({
    required this.cuenta,
    required this.dni,
    required this.apellido,
    required this.nombre,
    required this.telefono,
    required this.nacimiento,
    required this.sexo,
  });

  Cliente copyWith({
    int? cuenta,
    String? dni,
    String? apellido,
    String? nombre,
    String? telefono,
    DateTime? nacimiento,
    String? sexo,
  }) {
    return Cliente(
      cuenta: cuenta ?? this.cuenta,
      dni: dni ?? this.dni,
      apellido: apellido ?? this.apellido,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      nacimiento: nacimiento ?? this.nacimiento,
      sexo: sexo ?? this.sexo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cuenta': cuenta,
      'dni': dni,
      'apellido': apellido,
      'nombre': nombre,
      'telefono': telefono,
      'nacimiento': nacimiento.millisecondsSinceEpoch,
      'sexo': sexo,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      cuenta: map['cuenta']?.toInt() ?? 0,
      dni: map['dni'] ?? '',
      apellido: map['apellido'] ?? '',
      nombre: map['nombre'] ?? '',
      telefono: map['telefono'] ?? '',
      nacimiento: DateTime.fromMillisecondsSinceEpoch(map['nacimiento']),
      sexo: map['sexo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Cliente.fromJson(String source) => Cliente.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Cliente(cuenta: $cuenta, dni: $dni, apellido: $apellido, nombre: $nombre, telefono: $telefono, nacimiento: $nacimiento, sexo: $sexo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cliente &&
        other.cuenta == cuenta &&
        other.dni == dni &&
        other.apellido == apellido &&
        other.nombre == nombre &&
        other.telefono == telefono &&
        other.nacimiento == nacimiento &&
        other.sexo == sexo;
  }

  @override
  int get hashCode {
    return cuenta.hashCode ^
        dni.hashCode ^
        apellido.hashCode ^
        nombre.hashCode ^
        telefono.hashCode ^
        nacimiento.hashCode ^
        sexo.hashCode;
  }
}
