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
    this.dialCenter:280.0,
    this.dialRadius :180.0,
    this.shadowTranslation,
  }) {
    if(dialColor == null) {
      this.dialColor = _defaultDialColor();
    }
    if(platePaint == null) {
      this.platePaint = _defaultPlatePaint();
    }
    if(shadowPaint == null) {
      this.shadowPaint = _defaultShadowPaint();
    }
    if(shadowTranslation == null) {
      this.shadowTranslation = _defaultShadowTranslation();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {

    canvas.drawColor(dialColor, BlendMode.src );
    var shadowPath = _frontPlate(size,dialCenter,dialRadius).transform(shadowTranslation.storage);
    canvas.drawPath(shadowPath,shadowPaint);
    canvas.drawPath(_frontPlate(size,dialCenter,dialRadius),platePaint);
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
      paint.maskFilter = new MaskFilter.blur(BlurStyle.normal, 8.0);
      return paint;
  }

  Matrix4 _defaultShadowTranslation() {
    return new Matrix4.translationValues(0.0, 6.0, 0.0);
  }

  Path _frontPlate(Size screenSize, double dialCenterHeight, double dialRadius) {
      Path shadowPath = new Path();

      shadowPath.lineTo(screenSize.width/2, 0.0);
      shadowPath.lineTo(screenSize.width/2,screenSize.height);
      shadowPath.lineTo(screenSize.width/2,dialCenterHeight + dialRadius);
      var horizontalPadding = screenSize.width/2 - dialRadius;
      var topPadding = dialCenterHeight - dialRadius;
      var bottomPadding = screenSize.height - dialCenterHeight - dialRadius;
      var dialRectangle = new Rect.fromLTRB(horizontalPadding, topPadding, screenSize.width - horizontalPadding, screenSize.height - bottomPadding);
      shadowPath.arcTo(dialRectangle, -PI/2, -PI, false);
      shadowPath.arcTo(dialRectangle, PI/2, -PI, false);
      shadowPath.lineTo(screenSize.width/2, 0.0);
      shadowPath.lineTo(screenSize.width,0.0);
      shadowPath.lineTo(screenSize.width,screenSize.height);
      shadowPath.lineTo(0.0, screenSize.height);
      shadowPath.lineTo(0.0, screenSize.height/2);
      shadowPath.lineTo(0.0, 0.0);
      return shadowPath;
  }
}
