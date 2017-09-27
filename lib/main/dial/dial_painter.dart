import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'dart:ui';



class DialPainter extends CustomPainter {

  Paint platePaint;
  Color dialColor;
  Paint shadowPaint;

  DialPainter({
    this.platePaint,
    this.dialColor,
    this.shadowPaint,
  });


  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(dialColor, BlendMode.src);
    canvas.drawShadow(_createPath(size), shadowPaint.color, 2.0, false);
    canvas.drawPath(_createPath(size), platePaint);
  }

  @override
  bool shouldRepaint(DialPainter oldDelegate) {
    return false;
  }

  Path _createPath(Size size) {
    Path path = new Path();
    path.addOval(new Rect.fromLTRB(0.0, 0.0, size.width, size.height));
    return path;
  }

}