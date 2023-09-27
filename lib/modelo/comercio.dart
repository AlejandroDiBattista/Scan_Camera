import 'dart:convert';

class Comercio {
  int cuenta;
  String cuit;
  String domicilio;
  Comercio({
    required this.cuenta,
    required this.cuit,
    required this.domicilio,
  });

  Comercio copyWith({
    int? cuenta,
    String? cuit,
    String? domicilio,
  }) {
    return Comercio(
      cuenta: cuenta ?? this.cuenta,
      cuit: cuit ?? this.cuit,
      domicilio: domicilio ?? this.domicilio,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cuenta': cuenta,
      'cuit': cuit,
      'domicilio': domicilio,
    };
  }

  factory Comercio.fromMap(Map<String, dynamic> map) {
    return Comercio(
      cuenta: map['cuenta']?.toInt() ?? 0,
      cuit: map['cuit'] ?? '',
      domicilio: map['domicilio'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Comercio.fromJson(String source) => Comercio.fromMap(json.decode(source));

  @override
  String toString() => 'Comercio(cuenta: $cuenta, cuit: $cuit, domicilio: $domicilio)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comercio && other.cuenta == cuenta && other.cuit == cuit && other.domicilio == domicilio;
  }

  @override
  int get hashCode => cuenta.hashCode ^ cuit.hashCode ^ domicilio.hashCode;
}
