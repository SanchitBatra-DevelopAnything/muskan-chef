import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatelessWidget {
  final bool special;
  const MainDrawer({Key? key, required this.special}) : super(key: key);

  Widget buildTile(String title, IconData icon, VoidCallback tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 22,
        color: Colors.red,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Container(
            child: Image.asset('assets/muskan.png', fit: BoxFit.cover),
            width: double.infinity,
          ),
          SizedBox(
            height: 25,
          ),
          Divider(),
          buildTile('All Regular Items', Icons.breakfast_dining, () {
            Navigator.of(context)
                .pushReplacementNamed('/orders', arguments: "All");
          }),
          Divider(),
          special
              ? buildTile("SHOPS (Regular Orders)", Icons.shop_2_rounded, () {
                  Navigator.of(context).pushReplacementNamed('/shops');
                })
              : SizedBox(height: 0),
          Divider(),
          buildTile('Edit Item Counts', Icons.edit, () {
            Navigator.of(context).pushReplacementNamed('/orderWise');
          }),
          Divider(),
          buildTile('Custom Orders', Icons.cake, () {
            Navigator.of(context).pushReplacementNamed('/customOrders');
          }),
          Divider(),
        ],
      ),
    );
  }
}
