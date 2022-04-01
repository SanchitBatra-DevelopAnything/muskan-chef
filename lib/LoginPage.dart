import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
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
          const TextField(
            decoration: InputDecoration(
                labelText: "Chef Name",
                filled: true,
                labelStyle: const TextStyle(fontSize: 25)),
          ),
          const SizedBox(
            height: 20,
          ),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
                labelText: "Password",
                filled: true,
                labelStyle: const TextStyle(fontSize: 25)),
          ),
          const SizedBox(
            height: 20,
          ),
          RaisedButton(
            onPressed: () => {},
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
