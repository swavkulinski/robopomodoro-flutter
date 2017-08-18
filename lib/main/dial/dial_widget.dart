import 'package:flutter/material.dart';
import 'timer_painter.dart';
import '../di/main_module.dart';
import 'central_button.dart';
import '../digit/session_digit.dart';
import '../digit/minute_digit.dart';

class DialWidget extends StatelessWidget {


  static const DIAL_CENTER = 200.0;
  static const DIAL_RADIUS = 140.0;
  static const DEFAULT_COLOR = 0xFFA4C639;
  static const double radius = 45.0;
  final int elapsedTime;
  final VoidCallback onTapListener;
  final bool paused;
  final DateTime currentTime;
  final DateTime startTime;

  DialWidget({
    this.elapsedTime,
    this.onTapListener,
    this.paused,
    this.currentTime,
    this.startTime,
  }):assert(onTapListener != null);

  Widget build(BuildContext context) {

  var size = MediaQuery.of(context).size;
   return new Stack(children: <Widget>[
      new CustomPaint(
        size: size,
        painter: new TimerPainter(
            dialCenter: DIAL_CENTER,
            dialRadius: DIAL_RADIUS,
            dialColor: dialColor,
            platePaint: platePaint(),
            shadowPaint: defaultShadowPaint(),
            shadowTranslation: new Matrix4.translationValues(0.0, 2.0, 0.0),
        )
      ),
      new Transform(
          transform:
              new Matrix4.translationValues(size.width / 2, DIAL_CENTER, 0.0),
              child: new MinuteDigit(currentTime: currentTime, radius: DIAL_RADIUS - 10.0),
        ),
      new Transform(
        transform: new Matrix4.translationValues(
            size.width / 2 - radius, DIAL_CENTER - radius, 0.0),
        child: new CentralButton(onTapListener: onTapListener,radius: radius, paused: paused),
      ),
      new Transform(
          transform:
              new Matrix4.translationValues(size.width / 2, DIAL_CENTER, 0.0),
          child: new SessionDigit(
            radius: radius,
            elapsedTime: elapsedTime,
            startTime: startTime,
          ),
        ),
      new Transform(
        transform: new Matrix4.translationValues(size.width / 2, DIAL_CENTER + DIAL_RADIUS + 20.0, 0.0),
        child: new Text(currentTimeFormat.format(new DateTime.fromMillisecondsSinceEpoch(elapsedTime)),style: defaultTextStyle),
      )


    ]);
  }
}
