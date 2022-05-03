// ignore_for_file: deprecated_member_use

import 'dart:collection';

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
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isLoading = true;
    });

    fetchTodayOrders().then((_) {
      getShopsList().then((shoplist) {
        setState(() {
          shops = shoplist;
          isLoading = false;
        });
      });
    });
    super.initState();
  }

  var zeroOrders = false;
  var ordersLoaded = false;
  var isLoading = false;
  List<String> managedCategories = [];
  bool noManagedItems = true;
  List<Order> todaysOrders = [];
  List<String> shops = [];

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

  Future<List<String>> getShopsList() async {
    List<String> shopsForTodayOrders = [];
    var shared = await SharedPreferences.getInstance();
    var categoriesManaged = shared.getStringList('manages');
    for (var i = 0; i < todaysOrders.length; i++) {
      for (var j = 0; j < todaysOrders[i].items!.length; j++) {
        for (var k = 0; k < categoriesManaged!.length; k++)
          if (todaysOrders[i]
                  .items![j]["CategoryName"]
                  .toString()
                  .toLowerCase() ==
              categoriesManaged[k].toString().toLowerCase()) {
            shopsForTodayOrders.add(todaysOrders[i].shopAddress.toString());
          }
      }
    }
    if (shopsForTodayOrders.length == 0) {
      setState(() {
        noManagedItems = true;
        managedCategories = categoriesManaged!
            .map(
              (e) => e.toString().toLowerCase(),
            )
            .toList();
      });
    } else {
      setState(() {
        noManagedItems = false;
        managedCategories = categoriesManaged!
            .map(
              (e) => e.toString().toLowerCase(),
            )
            .toList();
      });
    }
    var uniqueValuesInShops = {...shopsForTodayOrders};
    return uniqueValuesInShops.toList();
  }

  Future<void> refreshOrders() async {
    return fetchTodayOrders().then((_) {
      getShopsList().then((shoplist) {
        setState(() {
          shops = shoplist;
          isLoading = false;
        });
      });
    });
  }

  void refreshAction() async {
    setState(() {
      isLoading = true;
      zeroOrders = false;
      noManagedItems = true;
    });
    return fetchTodayOrders().then((_) {
      getShopsList().then((shoplist) {
        setState(() {
          shops = shoplist;
          isLoading = false;
        });
      });
    });
  }

  void moveToOrders(BuildContext context, String shopName) {
    Navigator.of(context).pushReplacementNamed('/orders', arguments: shopName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("SHOPS"),
          actions: [
            IconButton(onPressed: refreshAction, icon: Icon(Icons.refresh)),
            IconButton(
                onPressed: () {
                  showLogoutDialog(context);
                },
                icon: Icon(Icons.login))
          ],
        ),
        drawer: MainDrawer(),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : (ordersLoaded && zeroOrders)
                ? RefreshIndicator(
                    onRefresh: refreshOrders,
                    child: Center(
                      child: Text(
                        'No orders',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  )
                : (ordersLoaded && noManagedItems)
                    ? Center(
                        child: Text(
                          'No Orders for you today.',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: refreshOrders,
                        child: ListView.builder(
                            itemCount: shops.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () =>
                                    moveToOrders(context, shops[index]),
                                child: Card(
                                  elevation: 12.0,
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.shop_rounded,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      shops[index].toString().toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    tileColor: Colors.redAccent,
                                  ),
                                ),
                              );
                            }),
                      ));
  }
}
