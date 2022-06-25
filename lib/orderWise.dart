import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:muskan_chef_app/MainDrawer.dart';
import 'package:muskan_chef_app/providers/orderWiseSegregation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderWise extends StatefulWidget {
  const OrderWise({Key? key}) : super(key: key);

  @override
  State<OrderWise> createState() => _OrderWiseState();
}

class _OrderWiseState extends State<OrderWise> {
  List<String> managedCategories = [];
  var isLoading = false;
  var _isFirstTime = true;
  var showError = false;

  @override
  void didChangeDependencies() {
    getManagedCategories();
    if (_isFirstTime) {
      setState(() {
        isLoading = true;
        showError = false;
      });
      Provider.of<OrderWiseSegregation>(context, listen: false)
          .fetchTodaysOrders()
          .then((value) => setState(() => {
                isLoading = false,
                showError = false,
              }))
          .catchError((error) => {
                setState(() => {
                      isLoading = false,
                      showError = true,
                    })
              });
      _isFirstTime = false;
    }
  }

  getManagedCategories() async {
    var shared = await SharedPreferences.getInstance();
    var categoriesManaged = shared.getStringList('manages');

    setState(() {
      managedCategories =
          categoriesManaged!.map((e) => e.toString().toLowerCase()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final allOrders = Provider.of<OrderWiseSegregation>(context).allOrders;
    return Scaffold(
        drawer: managedCategories.contains("ice cream") ||
                managedCategories.contains("cakes") ||
                managedCategories.contains("cakes & pastries")
            ? MainDrawer(special: true)
            : MainDrawer(special: false),
        appBar: AppBar(
            title: Text("Order Wise Segregation"), backgroundColor: Colors.red),
        body: showError
            ? Center(
                child: Text("Error"),
              )
            : isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                    ),
                  )
                : ListView.separated(
                    itemBuilder: (_, index) => ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed('/orderItems',
                                arguments: allOrders[index]);
                          },
                          title: Text(
                            allOrders[index].shopAddress!,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            allOrders[index].orderTime!,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: allOrders.length));
  }
}
