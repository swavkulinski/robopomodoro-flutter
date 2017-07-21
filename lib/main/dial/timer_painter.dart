import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'dart:ui';
import 'dart:math';

class TimerPainter extends CustomPainter {
  Paint platePaint;
  Color dialColor;
  Paint shadowPaint;
  Matrix4 shadowTranslation;

  double dialCenter;
  double dialRadius;

  TimerPainter({
    this.platePaint,
    this.dialColor,
    this.shadowPaint,
    this.shadowTranslation,
    this.dialCenter: 280.0,
    this.dialRadius: 180.0,
  }) : assert(platePaint != null),
  assert(dialColor != null),
  assert(shadowPaint != null),
  assert(shadowTranslation != null);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(dialColor, BlendMode.src);
    var shadowPath = _frontPlate(size, dialCenter, dialRadius)
        .transform(shadowTranslation.storage);
    canvas.drawPath(shadowPath, shadowPaint);
    canvas.drawPath(_frontPlate(size, dialCenter, dialRadius), platePaint);
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return false;
  }
  
  Path _frontPlate(
      Size screenSize, double dialCenterHeight, double dialRadius) {
    Path shadowPath = new Path();

    shadowPath.lineTo(screenSize.width / 2, 0.0);
    shadowPath.lineTo(screenSize.width / 2, dialCenterHeight - dialRadius);
    var dialRectangle = new Rect.fromCircle(
        center: new Offset(screenSize.width / 2, dialCenterHeight),
        radius: dialRadius);
    shadowPath.arcTo(dialRectangle, -PI / 2, -PI, false);
    shadowPath.arcTo(dialRectangle, PI / 2, -PI, false);
    shadowPath.lineTo(screenSize.width / 2, 0.0);
    shadowPath.lineTo(screenSize.width, 0.0);
    shadowPath.lineTo(screenSize.width, screenSize.height);
    shadowPath.lineTo(0.0, screenSize.height);
    shadowPath.lineTo(0.0, screenSize.height / 2);
    shadowPath.lineTo(0.0, 0.0);
    return shadowPath;
  }
  
}
