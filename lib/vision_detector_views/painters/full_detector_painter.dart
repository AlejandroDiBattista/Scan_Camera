import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'coordinates_translator.dart';

class FullDetectorPainter extends CustomPainter {
  FullDetectorPainter(
    this.barcodes,
    this.recognizedText,
    this.image,
    this.cameraLensDirection,
  );

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

  final colorTexto = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0
    ..color = Colors.lightGreenAccent;

  final colorFondo = Paint()..color = Color(0x99000000);

  void paintText(Canvas canvas) {
    if (recognizedText == null) return;

    for (final textBlock in recognizedText!.blocks) {
      dibujarTexto(canvas, textBlock.text, textBlock.boundingBox);
      dibujarPoints(canvas, textBlock.cornerPoints, true);
    }
  }

  void paintBarcode(Canvas canvas) {
    for (final Barcode barcode in barcodes) {
      dibujarTexto(canvas, barcode.displayValue!, barcode.boundingBox);
      dibujarPoints(canvas, barcode.cornerPoints, false);
    }
  }

  List<Offset> ubicarPuntos(List<Point<int>> points, [bool ajustar = false]) {
    final List<Offset> salida = <Offset>[];
    for (final point in points) {
      var o = ubicarPoint(point);
      if (ajustar) o = ajustarPoint(o);
      salida.add(o);
    }
    salida.add(salida.first);
    return salida;
  }

  void dibujarPoints(Canvas canvas, List<Point<int>> points, [bool ajustar = false]) {
    canvas.drawPoints(PointMode.polygon, ubicarPuntos(points, ajustar), colorTexto);
  }

  void dibujarTexto(Canvas canvas, String texto, Rect origen) {
    final ParagraphBuilder builder = ParagraphBuilder(ParagraphStyle(textAlign: TextAlign.left, fontSize: 12));
    builder.pushStyle(ui.TextStyle(color: colorTexto.color, background: colorFondo));
    builder.addText(texto);
    builder.pop();

    final r = moverRect(origen);
    canvas.drawParagraph(builder.build()..layout(ParagraphConstraints(width: (r.right - r.left).abs())), ubicarRect(r));
  }
}
