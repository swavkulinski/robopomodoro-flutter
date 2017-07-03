import 'package:flutter/material.dart';
import 'timer_painter.dart';
import 'main_module.dart';
import 'central_button.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const DIAL_CENTER = 280.0;
  static const DIAL_RADIUS = 180.0;
  static const DEFAULT_COLOR = 0xFFA4C639;
  static const double radius = 360.0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print("screen width:${size.width}");
    print("screen height:${size.height}");
    print("center:$DIAL_CENTER");
    print("fractional:${DIAL_CENTER/size.height}");
    return new Scaffold(
      body: new Stack(children: <Widget>[
        new Container(
          constraints: new BoxConstraints.expand(),
            child: new CustomPaint(
          painter: new TimerPainter(
              dialCenter: DIAL_CENTER, dialRadius: DIAL_RADIUS),
          //size: size,
          child: new Container(
            constraints: new BoxConstraints.tightFor(),
            alignment: new FractionalOffset.fromOffsetAndSize(new Offset(size.width/2,DIAL_CENTER), size),//(0.5,DIAL_CENTER/size.height),
            child: new GestureDetector(
              child: new CentralButton(
                size: new Size(radius, radius),
                bodyPaint: defaultPaint(),
                shadowPaint: defaultShadowPaint(),
              ),
            ),
          ),
        )),
      ]),
    );
  }
}
