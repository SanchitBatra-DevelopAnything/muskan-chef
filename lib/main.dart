import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:muskan_chef_app/OrderPage.dart';
import 'package:muskan_chef_app/SplashScreen.dart';
import 'package:muskan_chef_app/providers/customOrderProvider.dart';
import 'package:muskan_chef_app/providers/orderWiseSegregation.dart';
import 'package:muskan_chef_app/route_generator.dart';
import 'package:muskan_chef_app/shops.dart';
import 'package:provider/provider.dart';
import 'LoginPage.dart';
import 'notificationservice/local_notification_service.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CustomOrderProvider()),
        ChangeNotifierProvider(
          create: (context) => OrderWiseSegregation(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Muskan-Chef',
        theme: ThemeData(
          primarySwatch: Colors.red,
          canvasColor: Color.fromARGB(255, 246, 248, 248),
        ),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        // routes: {
        //   '/': (context) => HomePage(),
        //   '/login': (context) => LoginPage(),
        //   '/orders': (context) => OrderPage(),
        //   '/shops': (context) => ShopsPage(),
        // });
      ),
    );
  }
}
