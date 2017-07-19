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
    this.dialCenter: 280.0,
    this.dialRadius: 180.0,
    this.shadowTranslation,
  }) {
    if (dialColor == null) {
      this.dialColor = _defaultDialColor();
    }
    if (platePaint == null) {
      this.platePaint = _defaultPlatePaint();
    }
    if (shadowPaint == null) {
      this.shadowPaint = _defaultShadowPaint();
    }
    if (shadowTranslation == null) {
      this.shadowTranslation = _defaultShadowTranslation();
    }
  }

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

  Color _defaultDialColor() => new Color(0xFFA4C639);

  Paint _defaultPlatePaint() {
    var paint = new Paint();
    paint.color = _defaultDialColor();
    return paint;
  }

  Paint _defaultShadowPaint() {
    var paint = new Paint();
    paint.color = new Color(0x66000000);
    paint.maskFilter = new MaskFilter.blur(BlurStyle.normal, 2.0);
    return paint;
  }

  Matrix4 _defaultShadowTranslation() {
    return new Matrix4.translationValues(0.0, 1.0, 0.0);
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

  /*void _drawDebug(Canvas canvas, Size size) {
    Paint _paint = new Paint();
    _paint.color = new Color(0xFF660000);
    _paint.strokeWidth = 2.0;
    _drawHorizontalDebug(canvas, 0.0, size, _paint);
    _drawHorizontalDebug(canvas, size.height, size, _paint);
    _drawHorizontalDebug(canvas, dialCenter, size, _paint);
    _drawHorizontalDebug(canvas, dialCenter - dialRadius, size, _paint);
    _drawHorizontalDebug(canvas, dialCenter + dialRadius, size, _paint);

    _drawVerticalDebug(canvas, 0.0, size, _paint);
    _drawVerticalDebug(canvas, size.width, size, _paint);
    _drawVerticalDebug(canvas, size.width / 2, size, _paint);
    _drawVerticalDebug(canvas, size.width / 2 - dialRadius, size, _paint);
    _drawVerticalDebug(canvas, size.width / 2 + dialRadius, size, _paint);
  }

  void _drawHorizontalDebug(
      Canvas canvas, double height, Size size, Paint paint) {
    canvas.drawLine(
        new Offset(0.0, height), new Offset(size.width, height), paint);
  }

  void _drawVerticalDebug(Canvas canvas, double width, Size size, Paint paint) {
    canvas.drawLine(
        new Offset(width, 0.0), new Offset(width, size.height), paint);
  }*/
}
