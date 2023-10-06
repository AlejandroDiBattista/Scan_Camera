import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'coordinates_translator.dart';

class FullDetectorPainter extends CustomPainter {
  FullDetectorPainter(this.barcodes, this.recognizedText, this.faces, this.image, this.cameraLensDirection);

  final List<Face> faces;
  final List<Barcode> barcodes;
  final RecognizedText? recognizedText;

  final InputImage image;
  final CameraLensDirection cameraLensDirection;

  Size get imageSize => image.metadata!.size;
  InputImageRotation get rotation => image.metadata!.rotation;

  @override
  void paint(Canvas canvas, Size size) {
    canvasSize = size;
    paintBarcode(canvas);
    paintText(canvas);
    paintFaces(canvas);
  }

  @override
  bool shouldRepaint(FullDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.barcodes != barcodes;
  }

  Size canvasSize = Size.zero;

  Rect moverRect(Rect origen) => translateRect(origen, canvasSize, imageSize, rotation, cameraLensDirection);
  Offset ubicarRect(Rect r) => locateRect(r, canvasSize, imageSize, rotation, cameraLensDirection);
  Offset ubicarPoint(Point o) => translatePoint(o, canvasSize, imageSize, rotation, cameraLensDirection);
  Offset ajustarPoint(Offset o) => locatePoint(o, canvasSize, imageSize, rotation, cameraLensDirection);

  List<Offset> ubicarPuntos(List<Point<int>> points, [bool ajustar = false]) =>
      locatePoints(points, ajustar, canvasSize, imageSize, rotation, cameraLensDirection);

  final colorTexto = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0
    ..strokeCap = StrokeCap.round
    ..color = Colors.yellow;

  final colorMarco = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0
    ..strokeCap = StrokeCap.round
    ..color = Colors.red;

  final colorFondo = Paint()..color = Color(0x99000000);

  void paintText(Canvas canvas) {
    if (recognizedText == null) return;

    var i = 0;
    for (final textBlock in recognizedText!.blocks) {
      i++;
      dibujarTexto(canvas, "$i ${textBlock.text}", textBlock.boundingBox);
      dibujarPoints(canvas, textBlock.cornerPoints, true);
    }
  }

  void paintBarcode(Canvas canvas) {
    for (final Barcode barcode in barcodes) {
      dibujarTexto(canvas, barcode.displayValue!, barcode.boundingBox);
      dibujarPoints(canvas, barcode.cornerPoints, false);
    }
  }

  void dibujarPoints(Canvas canvas, List<Point<int>> points, [bool ajustar = false]) {
    canvas.drawPoints(PointMode.polygon, ubicarPuntos(points, ajustar), colorMarco);
  }

  void dibujarTexto(Canvas canvas, String texto, Rect origen) {
    final ParagraphBuilder builder = ParagraphBuilder(ParagraphStyle(textAlign: TextAlign.left, fontSize: 8));
    builder.pushStyle(ui.TextStyle(color: colorTexto.color, background: colorFondo));
    builder.addText(texto);
    builder.pop();

    final r = moverRect(origen);
    canvas.drawParagraph(builder.build()..layout(ParagraphConstraints(width: (r.right - r.left).abs())), ubicarRect(r));
  }

  void paintFaces(Canvas canvas) {
    for (final Face face in faces) {
      final r = translateRect(face.boundingBox, canvasSize, imageSize, rotation, cameraLensDirection);
      canvas.drawRect(r, colorTexto);
      print("- $r");
      // for (final type in FaceContourType.values) {
      //   final contour = face.contours[type];
      //   if (contour?.points != null) {
      //     for (final Point point in contour!.points) {
      //       final p = translatePoint(point, canvasSize, imageSize, rotation, cameraLensDirection);
      //       canvas.drawCircle(p, 1, colorTexto);
      //     }
      //   }
      // }

      // for (final type in FaceLandmarkType.values) {
      //   final landmark = face.landmarks[type];
      //   if (landmark?.position != null) {
      //     final p = translatePoint(landmark!.position, canvasSize, imageSize, rotation, cameraLensDirection);
      //     canvas.drawCircle(p, 2, colorFondo);
      //   }
      // }
    }
  }
}
