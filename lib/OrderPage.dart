import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muskan_chef_app/item.dart';
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
  List<Item> biforcatedItemsList = [];

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

  void logout(BuildContext ctx) async {
    biforcatedItemsList = [];
    var shared = await SharedPreferences.getInstance();
    shared.clear();
    Navigator.of(ctx).pushReplacementNamed('/');
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
        status: itemObject["status"],
        subcategoryKey: itemObject["subcategoryKey"],
        weight: itemObject["weight"]);
    return item;
  }

  void formBiforcatedItemsList() async {
    var shared = await SharedPreferences.getInstance();
    var categoryManaged = shared.get('manages');
    for (var i = 0; i < todaysOrders.length; i++) {
      for (var j = 0; j < todaysOrders[i].items!.length; j++) {
        if (todaysOrders[i]
                .items![j]["CategoryName"]
                .toString()
                .toLowerCase() ==
            categoryManaged.toString().toLowerCase()) {
          var itemObject = todaysOrders[i].items![j];
          Item item = formItem(itemObject);
          biforcatedItemsList.add(item);
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isLoading = true;
    });
    fetchTodayOrders().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
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
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: FlatButton(
                  child: Text('See items'),
                  onPressed: () {
                    formBiforcatedItemsList();
                  },
                ),
              ));
  }
}
