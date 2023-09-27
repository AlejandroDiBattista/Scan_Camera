import 'dart:convert';

class Cuenta {
  int id;
  DateTime creacion;
  Cuenta({
    required this.id,
    required this.creacion,
  });

  Cuenta copyWith({
    int? id,
    DateTime? creacion,
  }) {
    return Cuenta(
      id: id ?? this.id,
      creacion: creacion ?? this.creacion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'creacion': creacion.millisecondsSinceEpoch,
    };
  }

  factory Cuenta.fromMap(Map<String, dynamic> map) {
    return Cuenta(
      id: map['id']?.toInt() ?? 0,
      creacion: DateTime.fromMillisecondsSinceEpoch(map['creacion']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Cuenta.fromJson(String source) => Cuenta.fromMap(json.decode(source));

  @override
  String toString() => 'Cuenta(id: $id, creacion: $creacion)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Cuenta &&
      other.id == id &&
      other.creacion == creacion;
  }

  @override
  int get hashCode => id.hashCode ^ creacion.hashCode;
}

