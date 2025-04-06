import 'package:flutter/material.dart';
import 'package:sign_ease/utils/colors_utils.dart';

class Hand extends StatefulWidget {
  const Hand({super.key});

  @override
  State<Hand> createState() => _HandState();
}

class _HandState extends State<Hand> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double expandedHeight = screenSize.height + 300;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("fffff"),
              hexStringToColor("fffff"),
              hexStringToColor("fffff"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/Logo.jpg',
            fit: BoxFit.fill,
            width: screenSize.width,
            height: 600,
          ),
        ),
      ),
    );
  }
}
