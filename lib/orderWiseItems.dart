import 'package:flutter/material.dart';
import 'package:muskan_chef_app/itemQuantityCounter.dart';
import 'package:muskan_chef_app/order.dart';
import 'package:muskan_chef_app/providers/orderWiseSegregation.dart';
import 'package:provider/provider.dart';

class OrderWiseItems extends StatefulWidget {
  final Order order;
  const OrderWiseItems({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderWiseItems> createState() => _OrderWiseItemsState();
}

class _OrderWiseItemsState extends State<OrderWiseItems> {
  var isUpdating = false;

  Future<void> editCount(String orderId, int itemIndex, int updatedCount) {
    return Provider.of<OrderWiseSegregation>(context, listen: false)
        .updateItemCount(orderId, itemIndex, updatedCount);
  }

  @override
  Widget build(BuildContext context) {
    var items = widget.order.items;
    return Scaffold(
      appBar: AppBar(
        title: Text("ITEMS OF ORDER"),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.done_all,
              ),
            ),
          ),
        ],
      ),
      body: isUpdating
          ? Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      strokeWidth: 5,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Updating data in database"),
                  ]),
            )
          : ListView.separated(
              itemBuilder: (_, index) => ListTile(
                    title: Text(
                      items![index]['item'],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Total ordered : ${items[index]['quantity']}",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    trailing: Container(
                      height: 40,
                      child: CountButtonView(
                          itemIndex: index,
                          plusDisabled: items[index]['yetToPrepare'] ==
                              items[index]['quantity'],
                          count: items[index]['yetToPrepare'],
                          max: items[index]['quantity'],
                          onChange: (count) {
                            setState(() {
                              isUpdating = true;
                            });
                            editCount(widget.order.orderId!, index, count)
                                .then((_) => {
                                      setState(() {
                                        isUpdating = false;
                                      })
                                    }); //future banaao isko.
                          },
                          orderId: widget.order.orderId!),
                    ),
                  ),
              separatorBuilder: (_, __) => const Divider(),
              itemCount: items!.length),
    );
  }
}
