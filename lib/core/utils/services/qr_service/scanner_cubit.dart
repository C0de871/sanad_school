// QR Scanner Cubit
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sanad_school/core/utils/services/qr_service/qr_service.dart';
import 'package:sanad_school/core/utils/services/qr_service/qr_state.dart';

import '../service_locator.dart';

class QrScannerCubit extends Cubit<QrScannerState> {
  final QrCodeScannerService _scannerService;
  late MobileScannerController controller;
  late AnimationController animationController;

  QrScannerCubit()
      : _scannerService = getIt(),
        super(const QrScannerState()) {
    controller = _scannerService.initializeController();
    controller.addListener(() {
      log("controller state is changed");
    });
    _checkPermission();
  }

  // Check camera permission
  Future<void> _checkPermission() async {
    emit(state.copyWith(isLoading: true));
    try {
      final hasPermission = await _scannerService.requestCameraPermission();
      log("does have permission $hasPermission");
      emit(state.copyWith(
        hasPermission: hasPermission,
        isLoading: false,
        errorMessage: hasPermission ? null : 'Camera permission denied',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error checking permission: $e',
      ));
    }
  }

  // Handle barcode detection
  void onBarcodeDetected(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    final result = _scannerService.processBarcodes(barcodes);
    log("${result ?? "unknown"}");
    if (result != null) {
      log("cubit detect code: ");
      stopScanning();
      emit(state.copyWith(
        scanResult: result,
        isDetected: true,
      ));
    }
  }

  // Toggle flashlight
  void toggleFlashlight() {
    _scannerService.toggleTorch();
    emit(state.copyWith(isTorchOn: !state.isTorchOn));
  }

  // Switch camera
  void switchCamera() {
    _scannerService.switchCamera();
    emit(state.copyWith(isFrontCamera: !state.isFrontCamera));
  }

  // Scan from gallery
  Future<void> scanFromGallery() async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await _scannerService.analyzeGalleryImage();
      stopScanning();
      emit(state.copyWith(
        scanResult: result,
        isLoading: false,
        isDetected: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error scanning from gallery: $e',
        isDetected: false,
      ));
    }
  }

  void startScanning() {
    // unawaited(controller.start());
    log("start the controller");

    animationController.repeat(reverse: true);
  }

  void stopScanning() {
    unawaited(controller.stop());
    log("stop the controller");
    animationController.stop();
  }

  @override
  Future<void> close() {
    log("scanner cubit is closed");
    controller.stop();
    _scannerService.disposeController();

    return super.close();
  }
}
