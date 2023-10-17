import 'dart:math';

typedef MapDyn = Map<String, dynamic>;
typedef ListDyn = List<dynamic>;

mixin Sistema {
  static MapDyn _actual = {};

  MapDyn get actual => _actual;

  // ListDyn claves(ListDyn camino) {
  //   return camino.map((k) => k is String ? k.toString() : k).toList();
  // }

  dynamic get(MapDyn data, ListDyn camino) {
    return camino.fold(data, (d, k) => d[k]);
  }

  bool has(MapDyn datos, ListDyn camino) {
    return get(datos, camino) != null;
  }

  MapDyn set(MapDyn datos, ListDyn camino, dynamic valor) {
    if (valor == null || igual(get(datos, camino), valor)) return datos;

    final clave = camino.first;
    final resto = camino.sublist(1);

    final nuevo = Map.from(datos) as MapDyn;
    nuevo[clave] = resto.isEmpty ? valor : set(nuevo[clave] ?? {}, resto, valor);

    return nuevo;
  }

  MapDyn add(MapDyn datos, ListDyn camino, dynamic valor) {
    final aux = get(datos, camino) ?? <ListDyn>[];
    aux.add(valor);
    return set(datos, camino, aux);
  }

  List<ListDyn> path(MapDyn datos, [ListDyn salida = const <ListDyn>[]]) {
    final result = <ListDyn>[];
    for (final entry in datos.entries) {
      final k = entry.key;
      final v = entry.value;
      if (v is MapDyn) {
        result.addAll(path(v, [...salida, k]));
      } else if (v is ListDyn) {
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

  dynamic diff(dynamic a, dynamic b) {
    if (igual(a, b)) return null;

    if (a is MapDyn && b is MapDyn) return diffMap(a, b);
    if (a is ListDyn && b is ListDyn) return diffList(a, b);

    return b;
  }

  MapDyn diffMap(MapDyn a, MapDyn b) {
    if (a.isEmpty && b.isEmpty) return MapDyn();
    final e = MapDyn();

    final keys = a.keys.toSet()..addAll(b.keys);
    for (final key in keys) {
      final d = diff(a[key], b[key]);
      if (d == null || d is MapDyn && d.isEmpty) continue;
      e[key] = d;
    }
    return e;
  }

  ListDyn diffList(ListDyn a, ListDyn b) {
    final n = max(a.length, b.length);

    final salida = <ListDyn>[];
    for (int i = 0; i < n; i++) {
      salida.add(igual(a[i], b[i]) ? null : diff(a[i], b[i]));
    }
    return salida;
  }

  dynamic merge(dynamic a, dynamic b) {
    if (a == b) return a;

    if (a is MapDyn && b is MapDyn) return mergeObject(a, b);
    if (a is ListDyn && b is ListDyn) return mergeArray(a, b);

    return b;
  }

  MapDyn mergeObject(MapDyn a, MapDyn b) {
    b.forEach((key, value) {
      a[key] = merge(a[key] ?? MapDyn(), value);
    });
    return a;
  }

  ListDyn mergeArray(ListDyn a, ListDyn b) {
    for (int i = 0; i < b.length; i++) {
      a[i] = merge(a[i] ?? MapDyn(), b[i]);
    }
    return a;
  }

  bool igual(dynamic a, dynamic b) {
    if (a is MapDyn && b is MapDyn) return igualMap(a, b);
    if (a is ListDyn && b is ListDyn) return igualList(a, b);
    return a == b;
  }

  bool igualMap(MapDyn a, MapDyn b) {
    return a.keys.every((key) => igual(a[key], b[key]));
  }

  bool igualList(ListDyn a, ListDyn b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (!igual(a[i], b[i])) return false;
    }
    return true;
  }

  set actual(MapDyn valor) {
    _actual = valor;
  }

  void commit(MapDyn anterior, MapDyn siguiente) {
    final proximo = reconcile(_actual, anterior, siguiente);
    if (proximo.isNotEmpty) {
      _actual = proximo;
    }
  }

  MapDyn reconcile(MapDyn actual, MapDyn anterior, MapDyn siguiente) {
    if (actual == anterior) return siguiente;

    final anteriorActual = diff(anterior, actual);
    final anteriorSiguiente = diff(anterior, siguiente);

    if (sinConflicto(anteriorActual, anteriorSiguiente)) return merge(actual, anteriorSiguiente);

    return MapDyn();
  }

  bool sinConflicto(MapDyn a, MapDyn b) {
    final pathA = path(a);
    final pathB = path(b);
    return pathA.every((element) => !pathB.contains(element));
  }
}
