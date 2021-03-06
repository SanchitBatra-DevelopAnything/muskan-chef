import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MainDrawer.dart';
import 'providers/customOrderProvider.dart';

class CustomOrderShops extends StatefulWidget {
  const CustomOrderShops({Key? key}) : super(key: key);

  @override
  _CustomOrderShopsState createState() => _CustomOrderShopsState();
}

class _CustomOrderShopsState extends State<CustomOrderShops> {
  var isLoading = false;
  var _isFirstTime = true;
  var ordersLoaded = false;
  var zeroOrders = false;

  List<String> managedCategories = [];

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      Provider.of<CustomOrderProvider>(context)
          .getCustomOrders()
          .then((_) => setState(() => {
                isLoading = false,
                ordersLoaded = true,
                zeroOrders =
                    Provider.of<CustomOrderProvider>(context, listen: false)
                            .customOrders
                            .length ==
                        0
              }));
    }
    _isFirstTime = false;
    getManagedCategories();
    super.didChangeDependencies();
  }

  getManagedCategories() async {
    var shared = await SharedPreferences.getInstance();
    var categoriesManaged = shared.getStringList('manages');

    setState(() {
      managedCategories =
          categoriesManaged!.map((e) => e.toString().toLowerCase()).toList();
    });
  }

  openCustomOrder(BuildContext context, dynamic customOrder) {
    Navigator.of(context).pushNamed('/customOrderView', arguments: {
      'imgUrl': customOrder.imgUrl,
      'cakeDescription': customOrder.cakeDescription,
      'shopAddress': customOrder.shopAddress,
      'customType': customOrder.customType
    });
  }

  Future<void> refreshOrders() async {
    setState(() {
      isLoading = true;
      zeroOrders = false;
      ordersLoaded = false;
    });

    Provider.of<CustomOrderProvider>(context)
        .getCustomOrders()
        .then((_) => setState(() => {
              isLoading = false,
              ordersLoaded = true,
              zeroOrders =
                  Provider.of<CustomOrderProvider>(context, listen: false)
                              .customOrders ==
                          null
                      ? true
                      : false
            }));
  }

  @override
  Widget build(BuildContext context) {
    final customOrders =
        Provider.of<CustomOrderProvider>(context, listen: false).customOrders;
    return Scaffold(
        appBar: AppBar(
          title: Text("Custom Orders"),
        ),
        drawer: managedCategories.contains("ice cream") ||
                managedCategories.contains("cakes & pastries") ||
                managedCategories.contains("cakes")
            ? MainDrawer(special: true)
            : MainDrawer(special: false),
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
                : RefreshIndicator(
                    onRefresh: refreshOrders,
                    child: ListView.builder(
                        itemCount: customOrders.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () =>
                                openCustomOrder(context, customOrders[index]),
                            child: Card(
                              elevation: 12.0,
                              child: ListTile(
                                leading: Icon(
                                  Icons.shop_rounded,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  customOrders[index]
                                      .shopAddress!
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                tileColor: Colors.red,
                              ),
                            ),
                          );
                        }),
                  ));
  }
}
