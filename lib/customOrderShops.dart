import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    super.didChangeDependencies();
  }

  openCustomOrder(BuildContext context, String shopName) {
    print("Open clicked");
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
    final shops =
        Provider.of<CustomOrderProvider>(context, listen: false).shops;
    return Scaffold(
        appBar: AppBar(
          title: Text("Custom Orders"),
        ),
        drawer: MainDrawer(special: true),
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
                        itemCount: shops.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => openCustomOrder(context, shops[index]),
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
