import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pos_test/data/enums.dart';
import 'package:pos_test/data/models/order_model.dart';
import 'package:pos_test/di/ss_providers.dart';
import 'package:pos_test/presenter/commons/common_widgets.dart';

import '../commons/common_methods.dart';

class ScanOrder extends ConsumerStatefulWidget {
  const ScanOrder({super.key});

  @override
  _ScanOrderState createState() => _ScanOrderState();
}

class _ScanOrderState extends ConsumerState<ScanOrder>
    with WidgetsBindingObserver {
  final _mobileScannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    formats: [BarcodeFormat.qrCode, BarcodeFormat.code39],
    facing: CameraFacing.back,
    detectionTimeoutMs: 1000,
    useNewCameraSelector: true,
    autoStart: true,
  );
  StreamSubscription<Object?>? _subscription;

  void _handleBarcodesCaptures(BarcodeCapture captures) {
    final screenMode = ref.read(scanStateOrderProvider.notifier);
    final vmProvider = ref.read(scanOrderViewModelProvider);
    final oid = captures.barcodes.toSet().firstOrNull?.displayValue ?? "";

    print("Scan stream ${captures.barcodes.length}.................");
    for (var action in captures.barcodes) {
      print(action.displayValue);
    }

    if (screenMode.state == ScanState.ORDER) {
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
    } else {
      // Product scan...
      final error = vmProvider.updateProductQuantityBy(oid, 1);
      handleScanErrors(context, error);
    }
  }

  @override
  void initState() {
    ref.read(scanOrderViewModelProvider)
      ..allProductsVerified = false
      ..lastItemResetTimer();
    WidgetsBinding.instance.addObserver(this);
    initSubscription();
    super.initState();
  }

  void initSubscription() {
    _subscription = _mobileScannerController.barcodes.listen((l) {
      print(
          "DV/LSC -> ${l.barcodes.firstOrNull?.displayValue}/${ref.read(scanOrderViewModelProvider).lastScannedCode}");
      if (l.barcodes.firstOrNull?.displayValue ==
          ref.read(scanOrderViewModelProvider).lastScannedCode) {
        return;
      }
      ref.read(scanOrderViewModelProvider).lastScannedCode =
          l.barcodes.firstOrNull?.displayValue ?? '';
      _handleBarcodesCaptures(l);
    });
    unawaited(_mobileScannerController.start());
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
              height: MediaQuery.sizeOf(context).height * 0.35,
              child: MobileScanner(
                controller: _mobileScannerController,
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
    // TODO remove below code
    initSubscription();
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await _mobileScannerController.stop();
  }
}

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.item,
  });

  final ObdupdateItem item;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
            boxShadow: const [
              BoxShadow(color: Colors.black38, blurRadius: 4, spreadRadius: 2)
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Checkbox(
                value: item.checkQuantity ==
                    (num.tryParse(item.pickedQuantity)?.toInt() ?? -1),
                onChanged: (_) {},
              ),
              spacerX(5),
              Expanded(child: commonText(item.articleCode)),
              commonText(
                  '${item.checkQuantity}/${num.tryParse(item.pickedQuantity)?.toStringAsFixed(0) ?? -1}')
            ]),
            ProgressLoader(item: item)
          ],
        ),
      ),
    );
  }
}
