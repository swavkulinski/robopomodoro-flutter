import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'dart:ui';
import 'dart:math';



class DialPainter extends CustomPainter {

  Paint platePaint;
  Color dialColor;
  Paint shadowPaint;
  Paint tickPaint;
  double tickLength = 5.0;

  DialPainter({
    this.platePaint,
    this.tickPaint,
    this.tickLength,
    this.dialColor,
    this.shadowPaint,
  });


  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawShadow(_createPath(size), shadowPaint.color, 2.0, false);
    canvas.drawPath(_createPath(size), platePaint);
    _drawTicks(canvas,size);
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

  void _drawTicks(Canvas canvas, Size size) {

    Matrix4 translateDialTransform = new Matrix4.translationValues(size.width/2, size.height/2, 0.0);
    Matrix4 rotateDialTransform = new Matrix4.rotationZ(PI/6);
    canvas.save();
    canvas.transform(translateDialTransform.storage);
    for (int counter = 0; counter < 60; counter += 5) {
      canvas.drawLine(
        new Offset(0.0,-size.height/2), 
        new Offset(0.0,-size.height/2+tickLength), 
        tickPaint);
        canvas.transform(rotateDialTransform.storage);
    }
    canvas.restore();
  }

}