import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pos_test/data/repository/order_repository.dart';

import '../../data/enums.dart';
import '../../data/models/order_model.dart';

abstract interface class IScanOrderViewModel {
  List<ObdupdateItem> productsByOrderId();
  void reset();
}


abstract interface class IScannerConstants {
  String currentOrderNo = "";
  String lastScannedCode = "";
}

abstract interface class IProductCheck {
  ObdupdateItem? returnIfProductExists(String skuId);
  ProductScanErrors updateProductQuantityBy(String skuId, int by);
  bool allProductsVerified = false;
}

class ScanOrderViewmodel with ChangeNotifier implements IScanOrderViewModel, IProductCheck, IScannerConstants {
  final IOrderRepository _orderRepository;

  Timer? lastItemTimer;

  ScanOrderViewmodel(this._orderRepository);

  List<ObdupdateItem> _productListByOrder = [];

  List<ObdupdateItem> get products => _productListByOrder;

  @override
  List<ObdupdateItem> productsByOrderId() {
    _productListByOrder = _orderRepository.fetchOrderById(currentOrderNo)?.obdupdateItems ?? [];
    notifyListeners();
    return _productListByOrder;
  }

  void lastItemResetTimer() async {
    lastItemTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      lastScannedCode = "";
    });
  }
  void disposeLastResetTimer() {
    lastItemTimer?.cancel();
  }

  @override
  void reset() {
    _productListByOrder = [];
    currentOrderNo = "";
    allProductsVerified = false;
    lastScannedCode = "";
    disposeLastResetTimer();
    lastItemResetTimer();
    notifyListeners();
  }

  @override
  String currentOrderNo = "";

  @override
  ObdupdateItem? returnIfProductExists(String skuId) {
    return _productListByOrder.where((test) => test.articleCode == skuId).firstOrNull;
  }

  @override
  ProductScanErrors updateProductQuantityBy(String skuId, int by) {
    final product = returnIfProductExists(skuId);
    if(product == null) return ProductScanErrors.NoProduct;
    print("Test/Real -> ${product.checkQuantity}/${product.pickedQuantity}");
    if(product.checkQuantity < (num.tryParse(product.pickedQuantity)?.toInt()??-1)) {
      _productListByOrder.firstWhere((test) => test.articleCode == skuId).checkQuantity = product.checkQuantity + by;
      allProductsVerified = _productListByOrder.where((test) => test.checkQuantity == (num.tryParse(test.pickedQuantity)?.toInt() ?? -1)).length == _productListByOrder.length;

      print("Test/Real Latest-> ${product.checkQuantity}/${product.pickedQuantity}");

      notifyListeners();
    } else {
      return ProductScanErrors.QuantityExceed;
    }
    return ProductScanErrors.NoError;
  }

  @override
  bool allProductsVerified = false;

  @override
  String lastScannedCode = "";
}