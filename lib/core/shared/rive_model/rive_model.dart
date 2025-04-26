// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:rive/rive.dart';

class RiveModel {
  final String src, artboard, stateMachineName;
  late SMIBool? status;

  RiveModel({
    required this.artboard,
    required this.src,
    required this.stateMachineName,
    this.status,
  });
  set setStatus(SMIBool state) {
    status = state;
  }
}
