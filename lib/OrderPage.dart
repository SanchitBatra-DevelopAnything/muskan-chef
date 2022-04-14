import 'dart:collection';

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
  List<Item> biforcatedItemsList = [];
  var date = DateTime.now().toString().split(" ")[0];
  String managedCategory = '';
  bool zeroOrders = false;
  bool noManagedItems = true;

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

  void logout(BuildContext ctx) async {
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

  Future<List<Item>> formBiforcatedItemsList() async {
    List<Item> requiredItemsList = [];
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
          requiredItemsList.add(item);
        }
      }
    }
    if (requiredItemsList.length == 0) {
      setState(() {
        noManagedItems = true;
        managedCategory = categoryManaged.toString().toLowerCase();
      });
    } else {
      setState(() {
        noManagedItems = false;
        managedCategory = categoryManaged.toString().toLowerCase();
      });
    }
    requiredItemsList = clubItemsTogether(requiredItemsList);
    return requiredItemsList;
  }

  List<Item> clubItemsTogether(List<Item> currentList) {
    LinkedHashMap map = LinkedHashMap<String, int>();
    for (var i = 0; i < currentList.length; i++) {
      Item currentItem = currentList[i];
      if (map.containsKey(currentItem.item!.toUpperCase())) {
        map.update(currentItem.item!.toUpperCase(),
            (oldValue) => (currentItem.yetToPrepare + oldValue).toInt());
      } else {
        map.putIfAbsent(
            currentItem.item!.toUpperCase(), () => currentItem.yetToPrepare);
      }
    }

    List<Item> kaamKiList = [];
    map.forEach((key, value) {
      kaamKiList.add(Item(yetToPrepare: value, item: key));
    });
    return kaamKiList;
  }

  Future<void> refreshOrders() async {
    return fetchTodayOrders().then((_) {
      formBiforcatedItemsList().then((itemlist) {
        setState(() {
          biforcatedItemsList = itemlist;
          isLoading = false;
        });
      });
    });
  }

  Future<void> preparedItems() async {
    setState(() {
      isLoading = true;
    });
    var todaysDate = DateTime.now();
    var year = todaysDate.year.toString();
    var month = todaysDate.month.toString();
    var day = todaysDate.day.toString();
    var date = day + month + year;
    for (var i = 0; i < todaysOrders.length; i++) {
      Order currentOrder = todaysOrders[i];
      List? items = currentOrder.items;
      String orderKey = currentOrder.orderId.toString();
      for (var j = 0; j < items!.length; j++) {
        if (items[j]["CategoryName"].toString().toLowerCase() ==
            managedCategory.toString().toLowerCase()) {
          print(managedCategory + " is being managed");
          //update here and then send to backend , only update the keys to be updated
          items[j] = {'yetToPrepare': 0, 'status': "PREPARED"};
          var url = Uri.parse(
              'https://muskan-admin-app-default-rtdb.firebaseio.com/ProcessedShopOrders/' +
                  date +
                  "/" +
                  orderKey +
                  "/items/$j.json");

          await http.patch(url, body: json.encode(items[j]));
        }
      }
      fetchTodayOrders().then((_) {
        formBiforcatedItemsList().then((itemlist) {
          setState(() {
            biforcatedItemsList = itemlist;
            isLoading = false;
          });
        });
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isLoading = true;
    });

    fetchTodayOrders().then((_) {
      formBiforcatedItemsList().then((itemlist) {
        setState(() {
          biforcatedItemsList = itemlist;
          isLoading = false;
        });
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
              icon: Icon(Icons.done_all),
              onPressed: preparedItems,
            ),
            IconButton(
                onPressed: () {
                  logout(context);
                },
                icon: Icon(Icons.login))
          ],
        ),
        body: isLoading
            ? RefreshIndicator(
                onRefresh: refreshOrders,
                child: Center(child: CircularProgressIndicator()))
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
                          'No ${managedCategory} items today yet.',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: refreshOrders,
                        child: ListView.builder(
                            itemCount: biforcatedItemsList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  biforcatedItemsList[index]
                                      .item
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                  biforcatedItemsList[index]
                                      .yetToPrepare
                                      .toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            }),
                      ));
  }
}
