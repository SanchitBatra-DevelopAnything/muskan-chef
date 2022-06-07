import 'package:flutter/material.dart';
import 'package:muskan_chef_app/LoginPage.dart';
import 'package:muskan_chef_app/OrderPage.dart';
import 'package:muskan_chef_app/SplashScreen.dart';
import 'package:muskan_chef_app/customOrderShops.dart';
import 'package:muskan_chef_app/shops.dart';

import 'chef.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/login':
        if (args is List<Chef>) {
          return MaterialPageRoute(
              builder: (_) => LoginPage(
                    chefList: args,
                  ));
        } else {
          return _errorRoute();
        }
      case '/shops':
        return MaterialPageRoute(builder: (_) => ShopsPage());
      case '/orders':
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => OrderPage(
                    shopName: args.toString(),
                  ));
        } else {
          return _errorRoute();
        }
      case '/customOrders':
        return MaterialPageRoute(builder: (_) => CustomOrderShops());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
          appBar: AppBar(
            title: Text("ERROR"),
          ),
          body: Center(
            child: Text("ERROR"),
          ));
    });
  }
}
