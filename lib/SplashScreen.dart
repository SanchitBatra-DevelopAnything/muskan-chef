// ignore_for_file: unnecessary_const, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:muskan_chef_app/chef.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Chef> allChefs = [];
  var isLoading = false;
  var dataLoaded = false;

  Future<void> fetchAllChefs() async {
    var url = Uri.parse(
        'https://muskan-admin-app-default-rtdb.firebaseio.com/chefs.json');
    try {
      final response = await http.get(url);
      var extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Chef> loadedChefs = [];
      extractedData.forEach((chefId, chefData) {
        loadedChefs.add(Chef(
            chefName: chefData['chefName'],
            chefId: chefId,
            password: chefData['password']));
      });
      setState(() {
        allChefs = loadedChefs.reversed.toList();
        dataLoaded = true;
      });
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Internet :(',
            style: TextStyle(color: Colors.red[300]),
          ),
          content: Text(
            'please internet area me jaake try kijiye.',
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
          dataLoaded = false;
        });
      });
    }
  }

  void startTheApp(BuildContext ctx) {
    Navigator.of(ctx).pushReplacementNamed('/login', arguments: allChefs);
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isLoading = true;
    });
    fetchAllChefs().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    //CHECK THE SHIFT PAGE LOGIC HERE.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? const Center(
                child: const CircularProgressIndicator(),
              )
            : dataLoaded
                ? Center(
                    child: RaisedButton(
                      child: Text('SEE ORDERS..',
                          style: const TextStyle(
                              fontSize: 35, color: Colors.white)),
                      color: Colors.red,
                      onPressed: () {
                        startTheApp(context);
                      },
                    ),
                  )
                : Center(
                    child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Bad Internet :( Please try again',
                      style: TextStyle(fontSize: 30),
                    ),
                  )));
  }
}
