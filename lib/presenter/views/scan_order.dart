import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pos_test/data/enums.dart';
import 'package:pos_test/data/models/order_model.dart';
import 'package:pos_test/di/ss_providers.dart';
import 'package:pos_test/presenter/commons/common_widgets.dart';

import '../commons/common_methods.dart';
import '../commons/porduct_tile.dart';
import '../commons/scanner_related.dart';

class ScanOrder extends ConsumerStatefulWidget {
  const ScanOrder({super.key});

  @override
  _ScanOrderState createState() => _ScanOrderState();
}

class _ScanOrderState extends ConsumerState<ScanOrder>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final _mobileScannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    formats: [BarcodeFormat.qrCode, BarcodeFormat.code39],
    facing: CameraFacing.back,
    detectionTimeoutMs: 500,
    useNewCameraSelector: true,
    autoStart: true,
  );
  late AnimationController _scanAnimationController;
  Animation<double>? _scanAnimation;
  StreamSubscription<Object?>? _subscription;

  @override
  void initState() {
    _scanAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));
    ref.read(scanOrderViewModelProvider)
      ..allProductsVerified = false
      ..lastItemResetTimer();
    WidgetsBinding.instance.addObserver(this);
    initSubscription();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final maxScanHeight = MediaQuery.sizeOf(context).height * 0.35;
    _scanAnimation = Tween<double>(begin: 0.0, end: maxScanHeight)
        .animate(_scanAnimationController);
    _scanAnimationController.repeat();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_mobileScannerController.value.isInitialized) {
      return;
    }
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        {
          initSubscription();
        }
      case AppLifecycleState.inactive:
        {
          unawaited(_subscription?.cancel());
          _subscription = null;
          unawaited(_mobileScannerController.stop());
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final maxScanHeight = size.height * 0.35;
    return Scaffold(
      appBar: SSAppBar(title: "Scan Orders", size: 22),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer(builder: (ctx1, refer, ch1) {
                  final value = refer.watch(scanStateOrderProvider);
                  return commonText(
                      value == ScanState.ORDER
                          ? 'Scan Order QR code'
                          : "Scan Product Barcode",
                      size: 18,
                      isBold: true);
                }),
                InkWell(
                    splashColor: Colors.red.shade50,
                    onTap: () {
                      reset();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: commonText('Reset', size: 12, color: Colors.red),
                    ))
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: maxScanHeight,
              child: Stack(
                children: [
                  ScannerBar(mobileScannerController: _mobileScannerController),
                  ScannerLine(scanAnimationController: _scanAnimationController, scanAnimation: _scanAnimation),
                ],
              ),
            ),
            spacerY(6),
            productList()
          ],
        ),
      ),
      floatingActionButton: Consumer(
        builder: (ctx, ref3, child3) {
          final value =
              ref3.watch(scanOrderViewModelProvider).allProductsVerified;
          return value
              ? FloatingActionButton(
                  onPressed: () {
                    showOrderVerified(context).then((onValue) {
                      reset();
                    });
                  },
                  backgroundColor: Colors.black87,
                  child: const Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }

  void _handleBarcodesCaptures(BarcodeCapture captures) {
    final screenMode = ref.read(scanStateOrderProvider.notifier);
    final vmProvider = ref.read(scanOrderViewModelProvider);
    final oid = captures.barcodes.toSet().firstOrNull?.displayValue ?? "";
    switch(screenMode.state) {
      case ScanState.ORDER: {
        if (oid.isNotEmpty) {
          vmProvider
            ..currentOrderNo = oid
            ..productsByOrderId();
          if (vmProvider.products.isEmpty) {
            vmProvider.currentOrderNo = '';
          } else {
            screenMode.state = ScanState.PRODUCT;
          }
        }
      }
      break;
      case ScanState.PRODUCT: {
        final error = vmProvider.updateProductQuantityBy(oid, 1);
        handleScanErrors(context, error);
      }
    }
  }

  void initSubscription() {
    _subscription = _mobileScannerController.barcodes.listen((scan) {
      if (scan.barcodes.firstOrNull?.displayValue ==
          ref.read(scanOrderViewModelProvider).lastScannedCode) {
        return;
      }
      ref.read(scanOrderViewModelProvider).lastScannedCode =
          scan.barcodes.firstOrNull?.displayValue ?? '';

      _handleBarcodesCaptures(scan);
    });
    unawaited(_mobileScannerController.start());
  }

  Widget productList() {
    return Expanded(child: Consumer(builder: (ctx2, ref2, child2) {
      final products = ref2.watch(scanOrderViewModelProvider).products;
      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctxList, index) {
          final ObdupdateItem item = products[index];
          return ProductTile(item: item);
        },
      );
    }));
  }

  void reset() {
    ref.read(scanStateOrderProvider.notifier).state = ScanState.ORDER;
    ref.read(scanOrderViewModelProvider).reset();
  }

  @override
  void dispose() async {
    reset();
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    _scanAnimationController.dispose();
    super.dispose();
    await _mobileScannerController.stop();
  }
}