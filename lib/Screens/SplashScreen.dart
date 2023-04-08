import 'dart:async';

import 'package:expensebalance/Screens/ExpenseAddDataScreen.dart';
import 'package:expensebalance/Screens/Homepage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void Applaunch() {
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Homepage(),
      ));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Applaunch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text(
            "Expenses Balance",
            style: TextStyle(fontFamily: "Lato", fontSize: 34),
          )),
        ],
      ),
    );
  }
}
