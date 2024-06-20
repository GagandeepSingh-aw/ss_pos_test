import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pos_test/data/enums.dart';
import 'package:pos_test/presenter/commons/scan_border.dart';

class Scanner extends StatelessWidget {
  const Scanner(
      {super.key,
      required MobileScannerController mobileScannerController,
      required this.scanState,
      required this.boxSize})
      : _mobileScannerController = mobileScannerController;

  final MobileScannerController _mobileScannerController;
  final ScanState scanState;
  final Size boxSize;
  final double orderQrRatio = 0.63;

  @override
  Widget build(BuildContext context) {
    final rect = Rect.fromCenter(
      center: boxSize.center(Offset.zero),
      width:
          scanState == ScanState.ORDER ? boxSize.height * orderQrRatio : boxSize.width,
      height:
          scanState == ScanState.ORDER ? boxSize.height * orderQrRatio : boxSize.height,
    );
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: const BoxDecoration(
                color:Colors.white,
                boxShadow: [
              BoxShadow(color: Colors.black45, blurRadius: 2, spreadRadius: 2)
            ]),
            child: MobileScanner(
              controller: _mobileScannerController,
              scanWindow: rect,
            ),
          ),
        ),
        scanState == ScanState.PRODUCT
            ? const Center(
                child: Divider(
                  color: Colors.red,
                  thickness: 2,
                  height: 2,
                ),
              )
            : const SizedBox(),
        ValueListenableBuilder(
          valueListenable: _mobileScannerController,
          builder: (cts, controller, child) {
            if (!controller.isInitialized ||
                !controller.isRunning && controller.error != null) {
              return const SizedBox();
            }
            return CustomPaint(
              painter: ScannerOverlay(scanWindow: rect, borderRadius: 10),
            );
          },
        )
      ],
    );
  }
}
