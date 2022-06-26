import 'dart:convert';

import 'package:flutter/material.dart';

import '../order.dart';
import 'package:http/http.dart' as http;

class OrderWiseSegregation with ChangeNotifier {
  List<Order> _allOrders = [];

  List<Order> get allOrders {
    return [..._allOrders];
  }

  Future<void> updateItemCount(
      String orderId, int itemIndex, int updatedCount) async {
    print("TRIGGERED UPDATE");
    var todaysDate = DateTime.now();
    var year = todaysDate.year.toString();
    var month = todaysDate.month.toString();
    var day = todaysDate.day.toString();
    var date = day + month + year;
    var index = itemIndex.toString();
    print("item index going is ${index}");
    var url = Uri.parse(
        'https://muskan-admin-app-default-rtdb.firebaseio.com/ProcessedShopOrders/' +
            date +
            '/' +
            orderId +
            '/items/' +
            index +
            '.json');
    try {
      final response = await http.patch(url,
          body: json.encode({'yetToPrepare': updatedCount}));
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchTodaysOrders() async {
    var todaysDate = DateTime.now();
    var year = todaysDate.year.toString();
    var month = todaysDate.month.toString();
    var day = todaysDate.day.toString();
    var date = day + month + year;
    var url = Uri.parse(
        'https://muskan-admin-app-default-rtdb.firebaseio.com/ProcessedShopOrders/' +
            date +
            '.json');
    try {
      final response = await http.get(url);
      if (response == "null") {
        _allOrders = [];
        notifyListeners();
        return;
      } else {
        var extractedData = json.decode(response.body) as Map<String, dynamic>;
        final List<Order> loadedOrders = [];
        extractedData.forEach((processedOrderId, OrderData) {
          loadedOrders.add(Order(
            items: OrderData['items'],
            orderId: processedOrderId,
            orderedBy: OrderData['orderedBy'],
            shopAddress: OrderData['shopAddress'],
            orderTime: OrderData['orderTime'],
            totalPrice: OrderData['totalPrice'],
          ));
        });
        _allOrders = [...loadedOrders].reversed.toList();
        notifyListeners();
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
