import 'dart:convert';

class Movimiento {
  int origen;
  int destino;
  DateTime fecha;
  double monto;
  Movimiento({
    required this.origen,
    required this.destino,
    required this.fecha,
    required this.monto,
  });

  Movimiento copyWith({
    int? origen,
    int? destino,
    DateTime? fecha,
    double? monto,
  }) {
    return Movimiento(
      origen: origen ?? this.origen,
      destino: destino ?? this.destino,
      fecha: fecha ?? this.fecha,
      monto: monto ?? this.monto,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'origen': origen,
      'destino': destino,
      'fecha': fecha.millisecondsSinceEpoch,
      'monto': monto,
    };
  }

  factory Movimiento.fromMap(Map<String, dynamic> map) {
    return Movimiento(
      origen: map['origen']?.toInt() ?? 0,
      destino: map['destino']?.toInt() ?? 0,
      fecha: DateTime.fromMillisecondsSinceEpoch(map['fecha']),
      monto: map['monto']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Movimiento.fromJson(String source) => Movimiento.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Movimiento(origen: $origen, destino: $destino, fecha: $fecha, monto: $monto)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Movimiento &&
        other.origen == origen &&
        other.destino == destino &&
        other.fecha == fecha &&
        other.monto == monto;
  }

  @override
  int get hashCode {
    return origen.hashCode ^ destino.hashCode ^ fecha.hashCode ^ monto.hashCode;
  }
}
