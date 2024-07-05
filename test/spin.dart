import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Spin extends StatefulWidget {
  const Spin({super.key});

  @override
  State<Spin> createState() => _SpinState();
}

class _SpinState extends State<Spin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitWaveSpinner(
          color: Colors.blue,
            trackColor: Colors.red,
            size: 100,
          duration: Duration(seconds: 5),
        ),
      ),
    );
  }
}
