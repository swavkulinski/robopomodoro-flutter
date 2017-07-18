import 'package:flutter/material.dart';
import 'timer_painter.dart';
import 'main_module.dart';
import 'central_button.dart';
import 'session_digit.dart';
import '../app/models.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const DIAL_CENTER = 200.0;
  static const DIAL_RADIUS = 140.0;
  static const DEFAULT_COLOR = 0xFFA4C639;
  static const double radius = 45.0;

  var elapsedTime = 0;
  bool isPaused = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if(!isPaused){
      new Future.delayed(new Duration(seconds: 1)).whenComplete(()=> setState(()=> elapsedTime +=10000));
    }
    return new Stack(children: <Widget>[
      new CustomPaint(
        size: size,
        painter: new TimerPainter(
            dialCenter: DIAL_CENTER,
            dialRadius: DIAL_RADIUS,
            dialColor: dialColor,
            platePaint: platePaint(),
            shadowPaint: defaultShadowPaint()),
      ),
      new Transform(
        transform: new Matrix4.translationValues(
            size.width / 2 - radius, DIAL_CENTER - radius, 0.0),
        child: new GestureDetector(
            onTap: ()=> setState(()=> isPaused = !isPaused),
            child: new CustomPaint(
                size: new Size(radius * 2, radius * 2),
                painter: new CentralButtonPainter(
                    platePaint(), defaultShadowPaint()))),
      ),
      new Transform(
          transform:
              new Matrix4.translationValues(size.width / 2, DIAL_CENTER, 0.0),
          child: new CustomPaint(
            size: new Size(radius * 2, radius * 2),
            painter: new SessionPainter(
              sections: <Section>[
                new Section(
                  length: 1000 * 60 * 25,
                  foregroundPaint: workSectionCompletePaint,
                  backgroundPaint: workSectionIncompletePaint,
                  sessionType: SectionType.WORK,
                ),
                new Section(
                  length: 1000 * 60 * 5,
                  foregroundPaint: breakSectionCompletePaint,
                  backgroundPaint: breakSectionIncompletePaint,
                  sessionType: SectionType.BREAK,
                )
              ],
              dialOuterRadius: 135.0,
              dialInnerRadius: 50.0,
              elapsedLength: elapsedTime,
            ),
          ))
    ]);
  }
}

/*
*/
