import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pos_test/presenter/commons/common_methods.dart';

import '../../data/models/order_model.dart';

Future<void> showOrderVerified(BuildContext context) {
  return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                commonText("Thank you", color: Colors.black87, size: 20),
                spacerY(10),
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset('assets/images/ss_logo.jpeg', height: 90, width: 90,)),
                spacerY(20),
                const Icon(
                  Icons.done,
                  color: Colors.green,
                  size: 29,
                  shadows: [
                    Shadow(
                      color: Colors.green, blurRadius: 10
                    )
                  ],
                ),
                commonText("Order Verified", color: Colors.black87, size: 15, isBold: true),
              ],
            ),
          ));
}

Future<void> showCommonDialog(
    {required BuildContext context,
    required String title,
    required String message}) {
  return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                commonText(title, color: Colors.black87, size: 20),
                const SizedBox(
                  height: 20,
                ),
                commonText(message, color: Colors.black87, size: 15),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(onPressed: (){
                  Navigator.of(context).pop();
                }, style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.black87)
                ), child: commonText("Dismiss", color: Colors.white),)
              ],
            ),
          ));
}

class ProgressLoader extends StatelessWidget {
  const ProgressLoader({
    super.key,
    required this.item,
  });

  final ObdupdateItem item;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: item.checkQuantity/(num.tryParse(item.pickedQuantity)??1),
      backgroundColor: Colors.grey.shade200,
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.black54),
    );
  }
}

