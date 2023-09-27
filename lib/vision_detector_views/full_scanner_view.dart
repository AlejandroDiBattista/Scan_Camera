import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_ml_kit_example/modelo/cliente.dart';

import 'painters/full_detector_painter.dart';
import 'detector_view.dart';
import '../modelo/usuario.dart';

class FullScannerView extends StatefulWidget {
  @override
  State<FullScannerView> createState() => _FullScannerViewState();
}

class _FullScannerViewState extends State<FullScannerView> {
  final _barcodeScanner = BarcodeScanner();
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final _faceDetector = FaceDetector(options: FaceDetectorOptions(enableContours: true, enableLandmarks: true));

  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;

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
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

  List<Barcode> barcodes = [];
  RecognizedText? recognizedText;
  List<Face> faces = [];

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

    await _processBarcodeImage(inputImage);
    await _processTextImage(inputImage);
    // await _processFace(inputImage);

    final painter = FullDetectorPainter(barcodes, recognizedText, faces, inputImage, _cameraLensDirection);
    _customPaint = CustomPaint(painter: painter);

    _isBusy = false;
    if (!mounted) return;

    setState(() {});
  }

  Future<void> _processBarcodeImage(InputImage inputImage) async {
    barcodes = await _barcodeScanner.processImage(inputImage);

    if (barcodes.isNotEmpty) {
      for (final barcode in barcodes) {
        print('- |${barcode.rawValue}| ${barcode.format}\n');
        if (barcode.format == BarcodeFormat.qrCode && barcode.rawValue != null) {
          final c = await Cliente.cargar(barcode.rawValue!);
          if (c != null) {
            print('CLIENTE >>');
            print('- $c');
          }
        }
        if (barcode.format == BarcodeFormat.pdf417 && barcode.rawValue != null) {
          final u = Usuario.cargar(barcode.rawValue!);
          if (u != null) {
            print('USUARIO >>');
            print('- $u');
          }
        }
      }
    }

  }

  Future<void> _processTextImage(InputImage inputImage) async {
    recognizedText = await _textRecognizer.processImage(inputImage);
  }

  Future<void> _processFace(InputImage inputImage) async {
    faces = await _faceDetector.processImage(inputImage);
  }
}
