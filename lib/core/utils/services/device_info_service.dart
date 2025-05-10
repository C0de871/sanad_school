import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  late final AndroidDeviceInfo? _androidInfo;
  late final IosDeviceInfo? _iosInfo;

  Future<void> init() async {
    if (Platform.isAndroid) {
      _androidInfo = await _deviceInfo.androidInfo;
    } else if (Platform.isIOS) {
      _iosInfo = await _deviceInfo.iosInfo;
    }
  }

  String getDeviceId() {
    if (Platform.isAndroid) {
      return _androidInfo!.id;
    } else if (Platform.isIOS) {
      return _iosInfo!.identifierForVendor ?? '';
    }
    return '';
  }

  String getDeviceName() {
    if (Platform.isAndroid) {
      return _androidInfo!.brand;
    }
    return '';
  }

  bool isSamsung() {
    if (Platform.isAndroid) {
      return _androidInfo!.brand == 'samsung';
    }
    return false;
  }
}
