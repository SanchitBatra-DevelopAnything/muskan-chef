import 'package:flutter/material.dart';
import 'package:muskan_chef_app/order.dart';

class OrderWiseItems extends StatefulWidget {
  final Order order;
  const OrderWiseItems({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderWiseItems> createState() => _OrderWiseItemsState();
}

class _OrderWiseItemsState extends State<OrderWiseItems> {
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
      body: ListView.separated(
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
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.black,
                  size: 20,
                ),
              ),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: items!.length),
    );
  }
}
