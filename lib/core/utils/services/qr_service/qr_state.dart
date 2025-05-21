import 'package:equatable/equatable.dart';
import 'package:sanad_school/core/utils/services/qr_service/qr_result.dart';

class QrScannerState extends Equatable {
  final bool hasPermission;
  final QrCodeResult? scanResult;
  final bool isLoading;
  final String? errorMessage;
  final bool isTorchOn;
  final bool isFrontCamera;
  final bool isDetected;

  const QrScannerState({
    this.hasPermission = false,
    this.scanResult,
    this.isLoading = false,
    this.errorMessage,
    this.isTorchOn = false,
    this.isFrontCamera = false,
    this.isDetected = false,
  });

  QrScannerState copyWith({
    bool? hasPermission,
    QrCodeResult? scanResult,
    bool? isLoading,
    String? errorMessage,
    bool? isTorchOn,
    bool? isFrontCamera,
    bool? isDetected,
  }) {
    return QrScannerState(
      hasPermission: hasPermission ?? this.hasPermission,
      scanResult: scanResult ?? this.scanResult,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isTorchOn: isTorchOn ?? this.isTorchOn,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
      isDetected: isDetected ?? this.isDetected,
    );
  }

  @override
  List<Object?> get props => [
        hasPermission,
        scanResult,
        isLoading,
        errorMessage,
        isTorchOn,
        isFrontCamera,
        isDetected
      ];
}
