// ignore_for_file: unnecessary_const, deprecated_member_use

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:muskan_chef_app/chef.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notificationservice/local_notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Chef> allChefs = [];
  var isLoading = false;
  var dataLoaded = false;
  var moveToLogin = false;

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
            manages: List.from(chefData['manages']),
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
            'Issue!',
            style: TextStyle(color: Colors.red[300]),
          ),
          content: Text(
            error.toString(),
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

  void startTheApp(BuildContext ctx) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.get('loggedIn') == false ||
        sharedPreferences.get('loggedIn') == null) {
      moveToLogin = true;
      Navigator.of(ctx).pushReplacementNamed('/login', arguments: allChefs);
    } else {
      //check if still a valid login , access hataa to ni diya admin app se?
      var chef = sharedPreferences.get('chefName');
      var oldPassword = sharedPreferences.get('password');
      var chefInDB = false;
      for (var i = 0; i < allChefs.length; i++) {
        if (allChefs[i].chefName.toString().toLowerCase() ==
            chef.toString().toLowerCase()) {
          chefInDB = true;
          break;
        }
      }
      if (!chefInDB) {
        moveToLogin = true;
        sharedPreferences.clear();
        Navigator.of(ctx).pushReplacementNamed('/login', arguments: allChefs);
      }
    }
    if (!moveToLogin) {
      List<String> manages = sharedPreferences.getStringList('manages')!;
      if (manages.contains("CAKES & PASTRIES") ||
          manages.contains("PASTRIES") ||
          manages.contains("ICE CREAM")) {
        Navigator.of(ctx).pushReplacementNamed('/shops');
        return;
      }
      Navigator.of(ctx).pushReplacementNamed('/orders', arguments: "All");
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    //CHECK THE SHIFT PAGE LOGIC HERE.
    super.initState();

    //NOTIFICATION WORK
    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );

    setState(() {
      isLoading = true;
    });
    fetchAllChefs().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> clearPreferences() async {
    var sharedpref = await SharedPreferences.getInstance();
    sharedpref.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              'assets/muskan.png',
              height: 120,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to chef app',
              style: TextStyle(
                  fontSize: 20, fontStyle: FontStyle.italic, color: Colors.red),
            ),
            // SizedBox(height: 10),
            // RaisedButton(
            //   onPressed: () => {clearPreferences()},
            //   child: Text("CLEA"),
            // ),
            SizedBox(height: 10),
            isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  )
                : dataLoaded
                    ? Center(
                        child: ElevatedButton(
                          child: Text('SEE ORDERS..',
                              style: const TextStyle(
                                  fontSize: 35, color: Colors.white)),
                          style: ElevatedButton.styleFrom(primary: Colors.red),
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
                      ))
          ]),
        ));
    // return Scaffold(
    //     body: isLoading
    //         ? const Center(
    //             child: const CircularProgressIndicator(),
    //           )
    //         : dataLoaded
    //             ? Center(
    //                 child: RaisedButton(
    //                   child: Text('SEE ORDERS..',
    //                       style: const TextStyle(
    //                           fontSize: 35, color: Colors.white)),
    //                   color: Colors.red,
    //                   onPressed: () {
    //                     startTheApp(context);
    //                   },
    //                 ),
    //               )
    //             : Center(
    //                 child: Container(
    //                 padding: EdgeInsets.all(10),
    //                 child: Text(
    //                   'Bad Internet :( Please try again',
    //                   style: TextStyle(fontSize: 30),
    //                 ),
    //               )));
  }
}
