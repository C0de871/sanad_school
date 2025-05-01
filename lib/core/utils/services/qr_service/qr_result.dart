// QR Code Result Model
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeResult {
  final String code;
  final BarcodeType? format;

  QrCodeResult({required this.code, this.format});

  @override
  String toString() {
    return 'QR Code: $code (Format: ${format?.name ?? 'Unknown'})';
  }
}