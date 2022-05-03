import 'package:flutter/material.dart';
import 'package:muskan_chef_app/MainDrawer.dart';
import 'package:muskan_chef_app/item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'order.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({Key? key}) : super(key: key);

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  var zeroOrders = false;
  var ordersLoaded = false;
  var isLoading = false;
  List<Order> todaysOrders = [];
  List<Item> biforcatedItemsList = [];

  showLogoutDialog(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (ctx) => AlertDialog(
              title: Text(
                'LOGOUT?',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              content: Text(
                'Exit from the application?',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                FlatButton(
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                  onPressed: () {
                    logout(ctx);
                  },
                ),
                FlatButton(
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }

  void logout(BuildContext ctx) async {
    var shared = await SharedPreferences.getInstance();
    shared.clear();
    Navigator.of(ctx).pop();
    Navigator.of(ctx).pushReplacementNamed('/');
  }

  String getTodaysDate() {
    var todaysDate = DateTime.now();
    var year = todaysDate.year.toString();
    var month = todaysDate.month.toString();
    var day = todaysDate.day.toString();
    var date = day + "-" + month + "-" + year;
    return date;
  }

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
      if (response.body == "null") {
        setState(() {
          zeroOrders = true;
          ordersLoaded = true;
        });
      }
      if (!zeroOrders) {
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
        setState(() {
          todaysOrders = loadedOrders.reversed.toList();
          ordersLoaded = true;
        });
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Issue!',
            style: TextStyle(color: Colors.red[300]),
          ),
          content: Text(
            error.toString(),
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

  Item formItem(itemObject) {
    Item item = Item(
        CategoryKey: itemObject["CategoryKey"],
        CategoryName: itemObject["CategoryName"],
        yetToPrepare: itemObject["yetToPrepare"],
        quantity: itemObject["quantity"],
        item: itemObject["item"],
        itemKey: itemObject["itemKey"],
        price: itemObject["price"],
        cakeFlavour: itemObject['cakeFlavour'],
        designCategory: itemObject['designCategory'],
        status: itemObject["status"],
        subcategoryKey: itemObject["subcategoryKey"],
        weight: itemObject["weight"]);
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTodaysDate()),
        actions: [
          IconButton(onPressed: () => {}, icon: Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                showLogoutDialog(context);
              },
              icon: Icon(Icons.login))
        ],
      ),
      drawer: MainDrawer(),
    );
  }
}
