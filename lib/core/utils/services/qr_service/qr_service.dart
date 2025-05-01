// QR Code Scanner Service
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sanad_school/core/utils/services/qr_service/qr_result.dart';

class QrCodeScannerService {
  final ImagePicker _imagePicker = ImagePicker();
  MobileScannerController? _controller;

  // Initialize controller
  MobileScannerController initializeController() {
    _controller = MobileScannerController(
      // detectionSpeed: DetectionSpeed.normal,
      // facing: CameraFacing.back,
      // torchEnabled: false,
      // autoStart: false,
    );
    return _controller!;
  }

  // Dispose controller
  void disposeController() {
    _controller?.stop();
    _controller?.dispose();
    _controller = null;
  }

  // Check and request camera permission
  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    return status.isGranted;
  }

  // Toggle torch on/off
  void toggleTorch() {
    _controller?.toggleTorch();
  }

  // Switch between front and back camera
  void switchCamera() {
    _controller?.switchCamera();
  }

  // Process barcode detection
  QrCodeResult? processBarcode(Barcode barcode) {
    return QrCodeResult(
      code: barcode.rawValue ?? 'No data found',
      format: barcode.type,
    );
  }

  // Process multiple barcodes from detection
  QrCodeResult? processBarcodes(List<Barcode> barcodes) {
    if (barcodes.isNotEmpty) {
      return processBarcode(barcodes.first);
    }
    return null;
  }

  // Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
    return null;
  }

  // Analyze image from gallery
  Future<QrCodeResult?> analyzeGalleryImage() async {
    final File? image = await pickImageFromGallery();
    if (image != null && _controller != null) {
      try {
        final BarcodeCapture? barcodes = await _controller!.analyzeImage(image.path);
        if (barcodes?.barcodes.isNotEmpty ?? false) {
          return processBarcode(barcodes!.barcodes.first);
        } else {
          return QrCodeResult(
            code: 'No QR code found in the image',
            format: null,
          );
        }
      } catch (e) {
        return QrCodeResult(
          code: 'Error analyzing the image: $e',
          format: null,
        );
      }
    }
    return null;
  }
}
