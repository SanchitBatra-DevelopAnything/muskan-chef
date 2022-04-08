import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:muskan_chef_app/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  var isLoading = false;
  var ordersLoaded = false;
  List<Order> todaysOrders = [];
  var date = DateTime.now().toString().split(" ")[0];

  Future<void> fetchTodayOrders() async {
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
      var extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Order> loadedOrders = [];
      extractedData.forEach((processedOrderId, OrderData) {
        loadedOrders.add(Order(
          items: OrderData['items'],
          orderId: OrderData['orderId'],
          orderedBy: OrderData['orderedBy'],
          shopAddress: OrderData['shopAddress'],
          orderTime: OrderData['orderTime'],
          totalPrice: OrderData['totalPrice'],
        ));
      });
      setState(() {
        todaysOrders = loadedOrders.reversed.toList();
        ordersLoaded = true;
      });
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Internet :(',
            style: TextStyle(color: Colors.red[300]),
          ),
          content: Text(
            'please internet area me jaake try kijiye.',
            style: TextStyle(color: Colors.red[600]),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ).then((_) {
        setState(() {
          isLoading = false;
          ordersLoaded = false;
        });
      });
    }
  }

  void logout(BuildContext ctx) async {
    var shared = await SharedPreferences.getInstance();
    shared.clear();
    Navigator.of(ctx).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Orders for ' + date),
          actions: [
            IconButton(
                onPressed: () {
                  logout(context);
                },
                icon: Icon(Icons.login))
          ],
        ),
        body: Center(
          child: Text('Welcome to orders..'),
        ));
  }
}
