import 'package:flutter/material.dart';
import 'package:muskan_chef_app/chef.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final List<Chef> chefList;
  const LoginPage({Key? key, required this.chefList}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var chefNameController = TextEditingController();
  var passwordController = TextEditingController();
  var authProblem = false;
  var _isObscure = true;

  get chefList => null;

  void moveToOrders(List<dynamic?> manages) async {
    List<String> categoriesManaged = [];

    for (var i = 0; i < manages.length; i++) {
      categoriesManaged.add(manages[i].toString().toUpperCase());
    }

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('chefName', chefNameController.text);
    sharedPreferences.setString('password', passwordController.text);
    sharedPreferences.setStringList('manages', categoriesManaged);

    sharedPreferences.setBool('loggedIn', true);
    setState(() {
      authProblem = false;
    });

    if (categoriesManaged.contains("ICE CREAM") ||
        categoriesManaged.contains("PASTRIES") ||
        categoriesManaged.contains("CAKES & PASTRIES")) {
      Navigator.of(context).pushReplacementNamed('/shops');
      return;
    }

    Navigator.of(context).pushReplacementNamed('/orders', arguments: "All");
  }

  void checkAuth(List<Chef> allChefs) {
    var name = chefNameController.text;
    var password = passwordController.text;
    List<dynamic>? manages = [];

    var present = false;
    for (var i = 0; i < allChefs.length; i++) {
      var currentName = allChefs[i].chefName;
      if (currentName!.toLowerCase() == name.toLowerCase()) {
        if (allChefs[i].password == password) {
          present = true;
          manages = allChefs[i].manages;
          break;
        }
      }
    }
    if (present) {
      moveToOrders(manages!);
    } else {
      setState(() {
        authProblem = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final routeArgs = ModalRoute.of(context)!.settings.arguments as List<Chef>;
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
              Image.asset('assets/muskan.png'),
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
            obscureText: _isObscure,
            controller: passwordController,
            decoration: InputDecoration(
                labelText: "Password",
                filled: true,
                labelStyle: const TextStyle(fontSize: 25),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          RaisedButton(
            onPressed: () {
              checkAuth(widget.chefList);
            },
            child: const Text(
              'Login',
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
            color: Colors.red,
          ),
          authProblem
              ? Text(
                  'Incorrect username or password',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                )
              : Container()
        ],
      ),
    ));
  }
}
