import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sanad_school/core/utils/services/qr_service/qr_overlay.dart';
import 'package:sanad_school/core/utils/services/qr_service/qr_state.dart';
import 'package:sanad_school/core/utils/services/qr_service/scanner_cubit.dart';


class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrScannerCubit(),
      child: const _QrScannerView(),
    );
  }
}

class _QrScannerView extends StatefulWidget {
  const _QrScannerView();

  @override
  State<_QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<_QrScannerView> with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<QrScannerCubit>(context).animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animationController = BlocProvider.of<QrScannerCubit>(context).animationController;
    BlocProvider.of<QrScannerCubit>(context).startScanning();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
        actions: [
          BlocConsumer<QrScannerCubit, QrScannerState>(
            listener: (context, state) {
              log("is detected: ${state.isDetected}");
              if (state.isDetected) {
                log(state.scanResult?.code ?? "unknown");

                Navigator.pop(
                  context,
                  state.scanResult,
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<QrScannerCubit>();
              return Row(
                children: [
                  IconButton(
                    icon: Icon(
                      state.isTorchOn ? Icons.flash_on : Icons.flash_off,
                      color: state.isTorchOn ? Colors.yellow : null,
                    ),
                    onPressed: () => cubit.toggleFlashlight(),
                  ),
                  IconButton(
                    icon: Icon(
                      state.isFrontCamera ? Icons.camera_front : Icons.camera_rear,
                    ),
                    onPressed: () => cubit.switchCamera(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: () => cubit.scanFromGallery(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<QrScannerCubit, QrScannerState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<QrScannerCubit>();

          return Column(
            children: [
              Expanded(
                flex: 3,
                child: state.isLoading ? const Center(child: CircularProgressIndicator()) : _buildScannerView(context, state, cubit),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.scanResult?.code ?? 'Scan a QR code',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      if (state.scanResult != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          'Format: ${state.scanResult?.format?.name ?? 'Unknown'}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScannerView(
    BuildContext context,
    QrScannerState state,
    QrScannerCubit cubit,
  ) {
    if (!state.hasPermission) {
      return const Center(
        child: Text(
          'Camera permission denied',
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
      );
    }

    return ClipRect(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            MobileScanner(
              controller: cubit.controller,
              onDetect: cubit.onBarcodeDetected,
              fit: BoxFit.cover,
            ),
            BlocBuilder<QrScannerCubit, QrScannerState>(
              builder: (context, state) {
                return AnimatedBuilder(
                  animation: context.read<QrScannerCubit>().animationController,
                  builder: (context, child) {
                    return QRScannerOverlay(
                      scanAreaSize: 340,
                      animationValue: context.read<QrScannerCubit>().animationController.value,
                      isDetected: state.isDetected,
                      overlayColor: Colors.black, // Color of the shaded overlay
                      cornerColor: Colors.white, // Color of corner markers
                      lineColor: Colors.white, // Color of scanning line
                      cornerThickness: 4.0, // Thickness of corner markers
                      lineThickness: 3.0, // Thickness of scanning line
                      cornerLength: 40, // Length of corner markers
                      cornerRadius: 8.0, // Radius for rounded corners
                      scanLineMargin: 20.0, // Distance from line to border
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
