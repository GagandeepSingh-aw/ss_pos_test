enum ScanState {
  ORDER, PRODUCT
}
enum ProductScanErrors {
  NoProduct, QuantityExceed, NoError
}

extension ProductScanErrorsNames on ProductScanErrors {
  String getValueName() {
    return switch(this){
      ProductScanErrors.NoProduct => "No product found",
      ProductScanErrors.QuantityExceed => "Quantity exceeded",
      ProductScanErrors.NoError => "Done",
    };
  }
}