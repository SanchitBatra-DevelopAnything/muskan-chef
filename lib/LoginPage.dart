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
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        children: [
          Column(
            children: [
              SizedBox(
                height: 120,
              ),
              Image.asset('assets/muskan.jpeg'),
              SizedBox(
                height: 30,
              ),
              Text(
                'Chef Login',
                style: TextStyle(fontSize: 35, color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 60,
          ),
          TextField(
            decoration: InputDecoration(
                labelText: "Chef Name",
                filled: true,
                labelStyle: TextStyle(fontSize: 25)),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
                labelText: "Password",
                filled: true,
                labelStyle: TextStyle(fontSize: 25)),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            onPressed: () => {},
            child: Text(
              'Login',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            color: Colors.red,
          )
        ],
      ),
    ));
  }
}
