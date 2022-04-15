import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  Widget buildTile(String title, IconData icon, VoidCallback tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
        color: Colors.red,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: 24,
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
            height: 25,
          ),
          Container(
            child: Image.asset('assets/muskan.jpeg', fit: BoxFit.cover),
            width: double.infinity,
          ),
          SizedBox(
            height: 25,
          ),
          buildTile('Normal Orders', Icons.breakfast_dining, () {
            Navigator.of(context).pushReplacementNamed('/orders');
          }),
          buildTile('Custom Orders (coming soon)', Icons.cake, () {
            print("Coming Soon , Cant navigate now!");
          }),
        ],
      ),
    );
  }
}
