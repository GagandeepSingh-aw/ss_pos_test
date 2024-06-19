import 'package:flutter/material.dart';

import '../../data/enums.dart';
import 'common_widgets.dart';

AppBar SSAppBar({required String title, double size = 15}) {
  return AppBar(
    title: Text(title, style: TextStyle(fontSize: size, fontWeight: FontWeight.bold, color: Colors.black87),),
  );
}

void showSnackbar(BuildContext context, ProductScanErrors error, {Color color = Colors.black54}) {
  if(context.mounted) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
          content:
          commonText(error.getValueName(), color: Colors.white, size: 13),backgroundColor: color,));
  }
}

Widget commonText(
    String text,
    {double size = 15,
      Color color = Colors.black,
      bool isBold = false}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: size,
        color: color,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
  );
}

void handleScanErrors(BuildContext context, ProductScanErrors error) {
  switch (error) {
    case ProductScanErrors.NoProduct:
      {
        showSnackbar(context, error, color: Colors.red);
      }
    case ProductScanErrors.QuantityExceed:
      {
        if(context.mounted) {
          showCommonDialog(
              context: context,
              title: "Error",
              message: "Can't add more items than product cart count");
        }
      }
    case ProductScanErrors.NoError:
  }
}

SizedBox spacerX(double dim) => SizedBox(width: dim,);
SizedBox spacerY(double dim) => SizedBox(height: dim,);