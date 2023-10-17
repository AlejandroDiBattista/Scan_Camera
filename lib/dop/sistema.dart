mixin Sistema {
  static Map<String, dynamic> _actual = {};

  Map<String, dynamic> get actual => _actual;

  set actual(Map<String, dynamic> valor) {
    _actual = valor;
  }

  void commit(Map<String, dynamic> anterior, Map<String, dynamic> siguiente) {
    final proximo = reconcile(_actual, anterior, siguiente);
    if (proximo != null) {
      _actual = proximo;
    }
  }

  Map<String, dynamic> reconcile(Map<String, dynamic> actual, Map<String, dynamic> anterior, Map<String, dynamic> siguiente) {
    if (actual == anterior) {
      return siguiente;
    }

    final anteriorActual = diff(anterior, actual);
    final anteriorSiguiente = diff(anterior, siguiente);

    if (sinConflicto(anteriorActual, anteriorSiguiente)) {
      return merge(actual, anteriorSiguiente);
    }
    return null;
  }

  bool sinConflicto(Map<String, dynamic> a, Map<String, dynamic> b) {
    final pathA = path(a);
    final pathB = path(b);
    return pathA.every((element) => !pathB.contains(element));
  }

  Map<String, dynamic> diff(Map<String, dynamic> a, Map<String, dynamic> b) {
    // Implementa la función diff según tus necesidades.
    // Asumo que ya tienes una implementación de esta función en tu código.
    return null;
  }

  List<List<dynamic>> path(Map<String, dynamic> datos) {
    // Implementa la función path según tus necesidades.
    // Asumo que ya tienes una implementación de esta función en tu código.
    return [];
  }

  Map<String, dynamic> merge(Map<String, dynamic> a, Map<String, dynamic> b) {
    // Implementa la función merge según tus necesidades.
    // Asumo que ya tienes una implementación de esta función en tu código.
    return null;
  }
}
