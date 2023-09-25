import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'cliente.dart';
import 'detector_view.dart';
//import 'painters/barcode_detector_painter.dart';
//import 'painters/detector_view.dart';
import 'painters/full_detector_painter.dart';
import 'usuario.dart';
//import 'painters/painters/barcode_detector_painter.dart';
//import 'painters/text_detector_painter.dart';

class FullScannerView extends StatefulWidget {
  @override
  State<FullScannerView> createState() => _FullScannerViewState();
}

class _FullScannerViewState extends State<FullScannerView> {
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;

  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;

  @override
  void dispose() {
    _canProcess = false;
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      title: 'Full Scanner',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

  List<Barcode> barcodes = [];
  RecognizedText? recognizedText;

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() => _text = '');

    await _processBarcodeImage(inputImage);
    // await _processTextImage(inputImage);

    final painter = FullDetectorPainter(
        barcodes, recognizedText, inputImage.metadata!.size, inputImage.metadata!.rotation, _cameraLensDirection);
    _customPaint = CustomPaint(painter: painter);

    _isBusy = false;
    if (!mounted) return;

    setState(() {});
  }

  Future<void> _processBarcodeImage(InputImage inputImage) async {
    barcodes = await _barcodeScanner.processImage(inputImage);

    String text = 'Barcodes found: ${barcodes.length}\n';
    if (barcodes.isNotEmpty) {
      for (final barcode in barcodes) {
        text += '- |${barcode.rawValue}| ${barcode.format}\n';
        if (barcode.format == BarcodeFormat.qrCode) {
          final c = await Cliente.cargar(barcode.rawValue!);
          if (c != null) {
            print('CLIENTE >>');
            print('- $c');
          }
        }
        if (barcode.format == BarcodeFormat.pdf417) {
          final u = Usuario.cargar(barcode.rawValue!);
          if (u != null) {
            print('USUARIO >>');
            print('- $u');
          }
        }
      }

      // print(text);
    }

    if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) return;

    _text = text;
  }

  Future<void> _processTextImage(InputImage inputImage) async {
    recognizedText = await _textRecognizer.processImage(inputImage);
    if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) return;
    _text = 'Recognized text:\n\n${recognizedText!.text}';
  }
}
