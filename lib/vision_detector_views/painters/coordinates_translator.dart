import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

double translateX(
    double x, Size canvasSize, Size imageSize, InputImageRotation rotation, CameraLensDirection cameraLensDirection) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
      return x * canvasSize.width / (Platform.isIOS ? imageSize.width : imageSize.height);
    case InputImageRotation.rotation270deg:
      return canvasSize.width - x * canvasSize.width / (Platform.isIOS ? imageSize.width : imageSize.height);
    case InputImageRotation.rotation0deg:
    case InputImageRotation.rotation180deg:
      switch (cameraLensDirection) {
        case CameraLensDirection.back:
          return x * canvasSize.width / imageSize.width;
        default:
          return canvasSize.width - x * canvasSize.width / imageSize.width;
      }
  }
}

double translateY(
    double y, Size canvasSize, Size imageSize, InputImageRotation rotation, CameraLensDirection cameraLensDirection) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
    case InputImageRotation.rotation270deg:
      return y * canvasSize.height / (Platform.isIOS ? imageSize.height : imageSize.width);
    case InputImageRotation.rotation0deg:
    case InputImageRotation.rotation180deg:
      return y * canvasSize.height / imageSize.height;
  }
}

Rect translateRect(Rect origen, Size canvasSize, Size imageSize, InputImageRotation rotation,
    CameraLensDirection cameraLensDirection) {
  final left = translateX(origen.left, canvasSize, imageSize, rotation, cameraLensDirection);
  final top = translateY(origen.top, canvasSize, imageSize, rotation, cameraLensDirection);
  final right = translateX(origen.right, canvasSize, imageSize, rotation, cameraLensDirection);
  final bottom = translateY(origen.bottom, canvasSize, imageSize, rotation, cameraLensDirection);
  return Rect.fromLTRB(left, top, right, bottom);
}

Offset translatePoint(Point origen, Size canvasSize, Size imageSize, InputImageRotation rotation,
    CameraLensDirection cameraLensDirection) {
  final x = translateX(origen.x.toDouble(), canvasSize, imageSize, rotation, cameraLensDirection);
  final y = translateY(origen.y.toDouble(), canvasSize, imageSize, rotation, cameraLensDirection);
  return Offset(x, y);
}

Offset locateRect(
    Rect r, Size canvasSize, Size imageSize, InputImageRotation rotation, CameraLensDirection cameraLensDirection) {
  return Offset(Platform.isAndroid && cameraLensDirection == CameraLensDirection.front ? r.right : r.left, r.top);
}

Offset locatePoint(
    Offset o, Size canvasSize, Size imageSize, InputImageRotation rotation, CameraLensDirection cameraLensDirection) {
  if (Platform.isAndroid) {
    o = switch (cameraLensDirection) {
      CameraLensDirection.front => switch (rotation) {
          InputImageRotation.rotation180deg => Offset(canvasSize.width - o.dx, canvasSize.height - o.dy),
          InputImageRotation.rotation270deg => Offset(o.dy, canvasSize.height - o.dx),
          _ => o,
        },
      CameraLensDirection.back => switch (rotation) {
          InputImageRotation.rotation180deg => Offset(canvasSize.width - o.dx, canvasSize.height - o.dy),
          InputImageRotation.rotation90deg => Offset(canvasSize.width - o.dy, o.dx),
          _ => o
        },
      _ => o
    };
  }
  return Offset(o.dx, o.dy);
}

List<Offset> locatePoints(List<Point<int>> points, bool ajustar, Size canvasSize, Size imageSize,
    InputImageRotation rotation, CameraLensDirection cameraLensDirection) {
  final List<Offset> salida = <Offset>[];
  for (final point in points) {
    var o = translatePoint(point, canvasSize, imageSize, rotation, cameraLensDirection);
    if (ajustar) o = locatePoint(o, canvasSize, imageSize, rotation, cameraLensDirection);
    salida.add(o);
  }
  salida.add(salida.first);
  return salida;
}
