typedef MapDyn = Map<String, dynamic>;
typedef ListDyn = List<dynamic>;

extension ObjectExtension on Object {
  bool get isObject => this is Map;
  bool get isArray => this is List;
}

extension ArrayExtension on List {
  dynamic getAt(int index) {
    if (index >= length) {
      return null;
    }
    return this[index];
  }

  void setAt(int index, value) {
    while (index >= length) {
      add(null);
    }
    this[index] = value;
  }

  List<int> get keys => List<int>.generate(length, (i) => i);

  int get nextKey => length;
}

extension MapExtension on Map {
  dynamic get(String key) {
    return this[key];
  }

  void set(String key, value) {
    this[key] = value;
  }

  String nextKey() {
    final sortedKeys = keys.map((key) => key.toString()).toList()..sort();
    if (sortedKeys.isEmpty) {
      return '0';
    }
    return (int.parse(sortedKeys.last) + 1).toString();
  }
}

mixin DOP {
  ListDyn claves(ListDyn camino) {
    return camino.map((k) => k is String ? k.toString() : k).toList();
  }

  String nextKey(MapDyn datos) {
    final sortedKeys = datos.keys.map((key) => key.toString()).toList()..sort();
    if (sortedKeys.isEmpty) {
      return '0';
    }
    return (int.parse(sortedKeys.last) + 1).toString();
  }

  dynamic get(MapDyn data, ListDyn camino) {
    return claves(camino).fold(data, (d, k) => d[k]);
  }

  MapDyn set(MapDyn datos, ListDyn camino, dynamic valor) {
    if (valor == null) {
      return datos;
    }
    if (get(datos, camino) == valor) {
      return datos;
    }

    final clave = claves(camino).first;
    final resto = claves(camino).sublist(1);
    final nuevo = Map.from(datos) as MapDyn;
    nuevo[clave] = resto.isEmpty ? valor : set(nuevo[clave] ?? {}, resto, valor);
    return nuevo;
  }

  bool has(MapDyn datos, ListDyn camino) {
    return get(datos, camino) != null;
  }

  MapDyn add(MapDyn datos, ListDyn camino, dynamic valor) {
    final aux = get(datos, camino) ?? <dynamic>[];
    aux.add(valor);
    return set(datos, camino, aux);
  }

  dynamic diff(dynamic a, dynamic b) {
    if (a is MapDyn && b is MapDyn) {
      return diffObject(a, b);
    } else if (a is ListDyn && b is ListDyn) {
      return diffArray(a, b);
    } else if (a != b) {
      return b;
    } else {
      return null;
    }
  }

  ListDyn diffArray(ListDyn a, ListDyn b) {
    final n = a.length > b.length ? a.length : b.length;
    final diffList = <dynamic>[];
    for (int i = 0; i < n; i++) {
      diffList.add(a[i] == b[i] ? null : diff(a[i], b[i]));
    }
    return diffList;
  }

  MapDyn diffObject(MapDyn a, MapDyn b) {
    final e = a.isEmpty && b.isEmpty ? {} as MapDyn : a;
    if (a != b) {
      final keys = a.keys.toSet()..addAll(b.keys);
      for (final key in keys) {
        final d = diff(a[key], b[key]);
        if (d is Map && d.isEmpty || d == null) {
          continue;
        }
        e[key] = d;
      }
    }
    return e;
  }

  List<ListDyn> path(MapDyn datos, ListDyn salida) {
    final result = <ListDyn>[];
    for (final entry in datos.entries) {
      final k = entry.key;
      final v = entry.value;
      if (v is MapDyn) {
        result.addAll(path(v, [...salida, k]));
      } else if (v is List) {
        for (int i = 0; i < v.length; i++) {
          if (v[i] != null) {
            result.add([...salida, k, i]);
          }
        }
      } else {
        result.add([...salida, k]);
      }
    }
    return result;
  }

  MapDyn mergeObject(MapDyn a, MapDyn b) {
    b.forEach((key, value) {
      a[key] = merge(a[key] ?? {}, value);
    });
    return a;
  }

  ListDyn mergeArray(ListDyn a, ListDyn b) {
    for (int i = 0; i < b.length; i++) {
      a[i] = merge(a[i] ?? {}, b[i]);
    }
    return a;
  }

  dynamic merge(dynamic a, dynamic b) {
    if (a == b) {
      return a;
    } else if ((a is MapDyn && b is MapDyn) || (a is ListDyn && b is ListDyn)) {
      if (a is! Map) {
        a = <String, dynamic>{};
      }
      if (b is! Map) {
        b = <String, dynamic>{};
      }
      if (a is! List) {
        a = <dynamic>[];
      }
      if (b is! ListDyn) {
        b = <dynamic>[];
      }
      if (a is MapDyn) {
        return mergeObject(a, b);
      } else {
        return mergeArray(a, b);
      }
    } else {
      return b;
    }
  }

  bool igual(dynamic a, dynamic b) {
    if (a == b) {
      return true;
    } else if (a is MapDyn && b is MapDyn) {
      return a.keys.every((key) => igual(a[key], b[key]));
    }
    return false;
  }
}
