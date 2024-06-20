import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerLine extends StatelessWidget {
  const ScannerLine({
    super.key,
    required AnimationController scanAnimationController,
    required Animation<double>? scanAnimation,
  }) : _scanAnimationController = scanAnimationController, _scanAnimation = scanAnimation;

  final AnimationController _scanAnimationController;
  final Animation<double>? _scanAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scanAnimationController,
      builder: (coxB, childB) => Transform.translate(
        offset:
        Offset(0, (_scanAnimation?.value.toDouble() ?? 0.0)),
        child: const Divider(
          color: Colors.red,
          thickness: 2,
          height: 2,
        ),
      ),
    );
  }
}

class ScannerBar extends StatelessWidget {
  const ScannerBar({
    super.key,
    required MobileScannerController mobileScannerController,
  }) : _mobileScannerController = mobileScannerController;

  final MobileScannerController _mobileScannerController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(
                143, 0, 0, 1.0))
        ),
        child: MobileScanner(
          controller: _mobileScannerController,
        ),
      ),
    );
  }
}