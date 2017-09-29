import 'package:flutter/material.dart';
import '../di/main_module.dart';


class CentralButtonPainter extends CustomPainter {
  Paint bodyPaint;
  Paint shadowPaint;
  String label;

  CentralButtonPainter({this.bodyPaint,this.shadowPaint,this.label});

  @override
  bool shouldRepaint(CentralButtonPainter old) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var rectangle = new Rect.fromCircle(center: new Offset(size.width/2,size.height/2),radius:size.width/2);
    var shadowPath = new Path();
    shadowPath.addOval(rectangle);
    canvas.drawPath(shadowPath, shadowPaint);
    canvas.drawPath(shadowPath, bodyPaint);

    var text = textPainter(label);
    text.textDirection = TextDirection.ltr;
    text.layout();
    text.paint(canvas, new Offset((size.width - text.width)/2, (size.height - text.height)/2));

  }
}
