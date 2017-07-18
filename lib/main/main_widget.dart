import 'package:flutter/material.dart';
import 'timer_painter.dart';
import 'main_module.dart';
import 'central_button.dart';
import 'session_digit.dart';
import '../app/models.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const DIAL_CENTER = 240.0;
  static const DIAL_RADIUS = 120.0;
  static const DEFAULT_COLOR = 0xFFA4C639;
  static const double radius = 45.0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print("screen width:${size.width}");
    print("screen height:${size.height}");
    print("center:$DIAL_CENTER");
    print("fractional:${DIAL_CENTER/size.height}");
    return new Stack(children: <Widget>[
      new CustomPaint(
        size: size,
        painter: new TimerPainter(
            dialCenter: DIAL_CENTER,
            dialRadius: DIAL_RADIUS,
            shadowPaint: defaultShadowPaint()),
      ),
      new Transform(
        transform: new Matrix4.translationValues(
            size.width / 2 - radius, DIAL_CENTER - radius, 0.0),
        child: new CustomPaint(
            size: new Size(radius * 2, radius * 2),
            painter:
                new CentralButtonPainter(defaultPaint(), defaultShadowPaint())),
      ),
      new Transform(
          transform: new Matrix4.translationValues(
              size.width/2, DIAL_CENTER, 0.0),
          child: new CustomPaint(
            size: new Size(radius * 2, radius * 2),
            painter: new SessionPainter(
              sections: <Section>[
                new Section(
                  length: 1000 * 60 * 25,
                  color: new Color(0xFFDDDDDD),
                  sessionType: SectionType.WORK,
                ),
                new Section(
                  length: 1000 * 60 * 15,
                  color: brighterDialColor(),
                  sessionType: SectionType.BREAK,
                )
              ],
              dialOuterRadius: 115.0,
              dialInnerRadius: 50.0,
            ),
          ))
    ]);
  }
}

/*
*/
