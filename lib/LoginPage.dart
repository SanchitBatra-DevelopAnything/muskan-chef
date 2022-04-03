import 'package:flutter/material.dart';
import 'package:muskan_chef_app/chef.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var chefNameController = TextEditingController();
  var passwordController = TextEditingController();

  void moveToOrders() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('chefName', chefNameController.text);
    sharedPreferences.setString('password', passwordController.text);
    sharedPreferences.setBool('loggedIn', true);
  }

  void checkAuth(List<Chef> allChefs) {
    var name = chefNameController.text;
    var password = passwordController.text;

    var present = false;
    for (var i = 0; i < allChefs.length; i++) {
      var currentName = allChefs[i].chefName;
      if (currentName == name) {
        if (allChefs[i].password == password) {
          present = true;
          break;
        }
      }
    }
    print("auth = " + present.toString());
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as List<Chef>;
    return Scaffold(
        body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        children: [
          Column(
            children: [
              const SizedBox(
                height: 120,
              ),
              Image.asset('assets/muskan.jpeg'),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Chef Login',
                style: TextStyle(fontSize: 35, color: Colors.red),
              )
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          TextField(
            controller: chefNameController,
            decoration: InputDecoration(
                labelText: "Chef Name",
                filled: true,
                labelStyle: const TextStyle(fontSize: 25)),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(
                labelText: "Password",
                filled: true,
                labelStyle: const TextStyle(fontSize: 25)),
          ),
          const SizedBox(
            height: 20,
          ),
          RaisedButton(
            onPressed: () {
              checkAuth(routeArgs);
            },
            child: const Text(
              'Login',
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
            color: Colors.red,
          )
        ],
      ),
    ));
  }
}
