import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomOrderProvider with ChangeNotifier {
  List<CustomOrder> _customOrders = [];

  List<CustomOrder> get customOrders {
    return [..._customOrders];
  }

  List<String> _shopNames = [];

  List<String> get shops {
    _shopNames = [];
    for (var i = 0; i < _customOrders.length; i++) {
      _shopNames.add(_customOrders[i].shopAddress!);
    }
    return [..._shopNames];
  }

  Future<void> getCustomOrders() async {
    const url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/processedShopCustomOrders.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<CustomOrder> loadedCustomOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((orderId, orderData) {
        loadedCustomOrders.add(CustomOrder(
            orderId: orderId,
            shopAddress: orderData['shopAddress'],
            imgUrl: orderData['imgUrl'],
            cakeDescription: orderData['cakeDescription'],
            customType: orderData['customType']));
      });
      _customOrders = loadedCustomOrders;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

class CustomOrder {
  String? orderId;
  String? imgUrl;
  String? cakeDescription;
  String? customType;
  String? shopAddress;

  CustomOrder(
      {this.cakeDescription,
      this.customType,
      this.orderId,
      this.imgUrl,
      this.shopAddress});
}
