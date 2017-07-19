import 'package:flutter/material.dart';
import 'timer_painter.dart';
import 'main_module.dart';
import 'central_button.dart';
import 'session_digit.dart';
import '../app/models.dart';
import 'minute_digit.dart';

class DialWidget extends StatelessWidget {


  static const DIAL_CENTER = 200.0;
  static const DIAL_RADIUS = 140.0;
  static const DEFAULT_COLOR = 0xFFA4C639;
  static const double radius = 45.0;
  final int elapsedTime;
  final VoidCallback onTapListener;
  final bool paused;
  final int minute;

  DialWidget({
    this.elapsedTime,
    this.onTapListener,
    this.paused,
    this.minute,
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
            shadowPaint: defaultShadowPaint()),
      ),
      new Transform(
          transform:
              new Matrix4.translationValues(size.width / 2, DIAL_CENTER, 0.0),
              child: new MinuteDigit(minute: minute, radius: DIAL_RADIUS - 10.0),
        ),
      new Transform(
        transform: new Matrix4.translationValues(
            size.width / 2 - radius, DIAL_CENTER - radius, 0.0),
        child: new CentralButton(onTapListener: onTapListener,radius: radius, paused: paused),
      ),
      new Transform(
          transform:
              new Matrix4.translationValues(size.width / 2, DIAL_CENTER, 0.0),
          child: new CustomPaint(
            size: new Size(radius * 2, radius * 2),
            painter: new SessionDigitPainter(
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
          ),
        ),


    ]);
  }
}
