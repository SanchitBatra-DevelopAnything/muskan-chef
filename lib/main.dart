import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'test.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Muskan-Chef',
        theme: ThemeData(
          primarySwatch: Colors.red,
          canvasColor: Colors.white,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
        });
  }
}
