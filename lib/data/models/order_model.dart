import 'dart:convert';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  final List<Order> orders;

  OrderModel({
    required this.orders,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Order {
  final ObdupdateHeader obdupdateHeader;
  final List<ObdupdateItem> obdupdateItems;

  Order({
    required this.obdupdateHeader,
    required this.obdupdateItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        obdupdateHeader: ObdupdateHeader.fromJson(json["Obdupdate_Header"]),
        obdupdateItems: List<ObdupdateItem>.from(
            json["Obdupdate_Items"].map((x) => ObdupdateItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Obdupdate_Header": obdupdateHeader.toJson(),
        "Obdupdate_Items":
            List<dynamic>.from(obdupdateItems.map((x) => x.toJson())),
      };
}

class ObdupdateHeader {
  final String correlationId;
  final String transactionType;
  final String orderId;
  final String shipmentNo;
  final String sapSalesOrder;
  final String siteCode;
  final String wmsPickedTimeStamp;

  ObdupdateHeader({
    required this.correlationId,
    required this.transactionType,
    required this.orderId,
    required this.shipmentNo,
    required this.sapSalesOrder,
    required this.siteCode,
    required this.wmsPickedTimeStamp,
  });

  factory ObdupdateHeader.fromJson(Map<String, dynamic> json) =>
      ObdupdateHeader(
        correlationId: json["CorrelationID"],
        transactionType: json["TransactionType"]!,
        orderId: json["OrderID"],
        shipmentNo: json["ShipmentNo"],
        sapSalesOrder: json["SAPSalesOrder"],
        siteCode: json["SiteCode"],
        wmsPickedTimeStamp: json["WMSPickedTimeStamp"],
      );

  Map<String, dynamic> toJson() => {
        "CorrelationID": correlationId,
        "TransactionType": transactionType,
        "OrderID": orderId,
        "ShipmentNo": shipmentNo,
        "SAPSalesOrder": sapSalesOrder,
        "SiteCode": siteCode,
        "WMSPickedTimeStamp": wmsPickedTimeStamp,
      };
}

class ObdupdateItem {
  final String shipmentLineNumber;
  final String articleCode;
  final String pickedQuantity;
  final String originalQuantity;
  int checkQuantity;

  ObdupdateItem({
    required this.shipmentLineNumber,
    required this.articleCode,
    required this.pickedQuantity,
    required this.originalQuantity,
    this.checkQuantity = 0
  });

  factory ObdupdateItem.fromJson(Map<String, dynamic> json) => ObdupdateItem(
        shipmentLineNumber: json["ShipmentLineNumber"],
        articleCode: json["ArticleCode"],
        pickedQuantity: json["PickedQuantity"],
        originalQuantity: json["OriginalQuantity"],
      );

  Map<String, dynamic> toJson() => {
        "ShipmentLineNumber": shipmentLineNumber,
        "ArticleCode": articleCode,
        "PickedQuantity": pickedQuantity,
        "OriginalQuantity": originalQuantity,
      };
}
