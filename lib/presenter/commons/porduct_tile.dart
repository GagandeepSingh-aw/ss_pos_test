import 'package:flutter/material.dart';

import '../../data/models/order_model.dart';
import 'common_methods.dart';
import 'common_widgets.dart';

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