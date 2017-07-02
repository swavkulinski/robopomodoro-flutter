import 'package:flutter/material.dart';
import 'timer_painter.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return new Scaffold(
      body: new CustomPaint(painter: new TimerPainter(),size: size),
    );
  }
}
