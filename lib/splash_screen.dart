import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_plant_disease_app/home_page.dart';

class SPlashScreen extends StatefulWidget {
  @override
  State<SPlashScreen> createState() => _SPlashScreenState();
}

class _SPlashScreenState extends State<SPlashScreen> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(80),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.cover,
          
          ),
        ),
      ),
    );
  }
}
