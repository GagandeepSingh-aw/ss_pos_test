import '../models/order_model.dart';

abstract interface class IOrdersDb {
  List<Order> allOrders();

  Order? orderById(String orderId);
}

class OrdersDb implements IOrdersDb {
  final siteCode = "902";

  @override
  List<Order> allOrders() {
    final Map<String, List<Map<String, Object>>> ssOrdersMap = allSavedOrders;
    final OrderModel orders = OrderModel.fromJson(ssOrdersMap);
    return orders.orders
        .where((test) => test.obdupdateHeader.siteCode == siteCode)
        .toList();
  }

  @override
  Order? orderById(String orderId) {
    return allOrders()
        .where((test) => test.obdupdateHeader.orderId == orderId)
        .firstOrNull;
  }
}

// Somewhere in the cloud database...

final allSavedOrders = {
  "orders": [
    {
      "Obdupdate_Header": {
        "CorrelationID": "0000000148991057",
        "TransactionType": "OBD",
        "OrderID": "IF_1495",
        "ShipmentNo": "902-1-IF_1495",
        "SAPSalesOrder": "5101306505",
        "SiteCode": "902",
        "WMSPickedTimeStamp": "20240327 153012"
      },
      "Obdupdate_Items": [
        {
          "ShipmentLineNumber": "1",
          "ArticleCode": "S24K-JBSHIN403003",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        },
        {
          "ShipmentLineNumber": "2",
          "ArticleCode": "S24K-JBSHIN402003",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        },
      ]
    },
    {
      "Obdupdate_Header": {
        "CorrelationID": "0000000148991056",
        "TransactionType": "OBD",
        "OrderID": "IF_1492",
        "ShipmentNo": "902-1-IF_1492",
        "SAPSalesOrder": "5101306504",
        "SiteCode": "902",
        "WMSPickedTimeStamp": "20240327 153009"
      },
      "Obdupdate_Items": [
        {
          "ShipmentLineNumber": "1",
          "ArticleCode": "S24K-JBSHIN403003",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        },
        {
          "ShipmentLineNumber": "2",
          "ArticleCode": "S24K-JBSHIN402005",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        }
      ]
    },
    {
      "Obdupdate_Header": {
        "CorrelationID": "0000000148991055",
        "TransactionType": "OBD",
        "OrderID": "IF_1493",
        "ShipmentNo": "902-1-IF_1493",
        "SAPSalesOrder": "5101306503",
        "SiteCode": "902",
        "WMSPickedTimeStamp": "20240327 153005"
      },
      "Obdupdate_Items": [
        {
          "ShipmentLineNumber": "1",
          "ArticleCode": "S24K-JBSHIN402003",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        },
        {
          "ShipmentLineNumber": "2",
          "ArticleCode": "S24K-JBSHIN403003",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        }
      ]
    },
    {
      "Obdupdate_Header": {
        "CorrelationID": "0000000148961074",
        "TransactionType": "OBD",
        "OrderID": "IF_1477",
        "ShipmentNo": "902-1-IF_1477",
        "SAPSalesOrder": "5101306444",
        "SiteCode": "902",
        "WMSPickedTimeStamp": "20240322 143523"
      },
      "Obdupdate_Items": [
        {
          "ShipmentLineNumber": "1",
          "ArticleCode": "S24K-JBSHIN402005",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        },
        {
          "ShipmentLineNumber": "2",
          "ArticleCode": "S24K-JBSHIN403003",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        }
      ]
    },
    {
      "Obdupdate_Header": {
        "CorrelationID": "0000000148961073",
        "TransactionType": "OBD",
        "OrderID": "IF_1474",
        "ShipmentNo": "902-1-IF_1474",
        "SAPSalesOrder": "5101306443",
        "SiteCode": "902",
        "WMSPickedTimeStamp": "20240322 143519"
      },
      "Obdupdate_Items": [
        {
          "ShipmentLineNumber": "1",
          "ArticleCode": "S24K-JBSHIN402003",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        }
      ]
    },
    {
      "Obdupdate_Header": {
        "CorrelationID": "0000000148961072",
        "TransactionType": "OBD",
        "OrderID": "IF_1475",
        "ShipmentNo": "902-1-IF_1475",
        "SAPSalesOrder": "5101306442",
        "SiteCode": "902",
        "WMSPickedTimeStamp": "20240322 143516"
      },
      "Obdupdate_Items": [
        {
          "ShipmentLineNumber": "1",
          "ArticleCode": "S24K-JBSHIN403003",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        }
      ]
    },
    {
      "Obdupdate_Header": {
        "CorrelationID": "0000000148961071",
        "TransactionType": "OBD",
        "OrderID": "IF_1476",
        "ShipmentNo": "902-1-IF_1476",
        "SAPSalesOrder": "5101306441",
        "SiteCode": "902",
        "WMSPickedTimeStamp": "20240322 143512"
      },
      "Obdupdate_Items": [
        {
          "ShipmentLineNumber": "1",
          "ArticleCode": "S24K-JBSHIN402004",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        },
        {
          "ShipmentLineNumber": "2",
          "ArticleCode": "S24K-JBSHIN403003",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        }
      ]
    },
    {
      "Obdupdate_Header": {
        "CorrelationID": "0000000306119569",
        "TransactionType": "OBD",
        "OrderID": "IF_1516",
        "ShipmentNo": "902-1-IF_1516",
        "SAPSalesOrder": "5105009944",
        "SiteCode": "902",
        "WMSPickedTimeStamp": "20240329 174149"
      },
      "Obdupdate_Items": [
        {
          "ShipmentLineNumber": "1",
          "ArticleCode": "S23M-CATSHK028004",
          "PickedQuantity": "1.000",
          "OriginalQuantity": "1.000"
        },
        {
          "ShipmentLineNumber": "2",
          "ArticleCode": "S23M-CAPOLK189002",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        }
      ]
    },
    {
      "Obdupdate_Header": {
        "CorrelationID": "0000000149001085",
        "TransactionType": "OBD",
        "OrderID": "IF_1507",
        "ShipmentNo": "902-1-IF_1507",
        "SAPSalesOrder": "5101306538",
        "SiteCode": "902",
        "WMSPickedTimeStamp": "20240328 172154"
      },
      "Obdupdate_Items": [
        {
          "ShipmentLineNumber": "1",
          "ArticleCode": "S24K-JBSHIN403003",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        },
        {
          "ShipmentLineNumber": "2",
          "ArticleCode": "S24K-JBSHIN402003",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        }
      ]
    },
    {
      "Obdupdate_Header": {
        "CorrelationID": "0000000149001084",
        "TransactionType": "OBD",
        "OrderID": "IF_1508",
        "ShipmentNo": "902-1-IF_1508",
        "SAPSalesOrder": "5101306537",
        "SiteCode": "902",
        "WMSPickedTimeStamp": "20240328 172151"
      },
      "Obdupdate_Items": [
        {
          "ShipmentLineNumber": "1",
          "ArticleCode": "S24K-JBSHIN402003",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        },
        {
          "ShipmentLineNumber": "2",
          "ArticleCode": "S24K-JBSHIN403003",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        }
      ]
    },
    {
      "Obdupdate_Header": {
        "CorrelationID": "0000001148991058",
        "TransactionType": "OBD",
        "OrderID": "IF_1501",
        "ShipmentNo": "902-1-IF_1501",
        "SAPSalesOrder": "9101306506",
        "SiteCode": "902",
        "WMSPickedTimeStamp": "20240327 153016"
      },
      "Obdupdate_Items": [
        {
          "ShipmentLineNumber": "1",
          "ArticleCode": "S23K-JBTSHK041001",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "3.000"
        },
        {
          "ShipmentLineNumber": "2",
          "ArticleCode": "S24K-SBJOGGN330002",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "3.000"
        },
        {
          "ShipmentLineNumber": "3",
          "ArticleCode": "S24K-JBJOGGN329003",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "3.000"
        },
        {
          "ShipmentLineNumber": "4",
          "ArticleCode": "S24K-JBJOGGN322005",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "3.000"
        }
      ]
    },
    {
      "Obdupdate_Header": {
        "CorrelationID": "0000000148991058",
        "TransactionType": "OBD",
        "OrderID": "IF_1494",
        "ShipmentNo": "902-1-IF_1494",
        "SAPSalesOrder": "5101306506",
        "SiteCode": "902",
        "WMSPickedTimeStamp": "20240327 153016"
      },
      "Obdupdate_Items": [
        {
          "ShipmentLineNumber": "1",
          "ArticleCode": "S24K-JBSHIN403003",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        },
        {
          "ShipmentLineNumber": "2",
          "ArticleCode": "S24K-JBSHIN402005",
          "PickedQuantity": "2.000",
          "OriginalQuantity": "2.000"
        }
      ]
    }
  ]
};
