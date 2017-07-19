import 'package:flutter/material.dart';


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
    TextPainter textPainter = new TextPainter(
      text: new TextSpan(
       style: new TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.normal,
          color: new Color(0xFF000000),
       ),
       text: label,
    ),
      textAlign: TextAlign.center,
      maxLines: 1,
    );
    textPainter.layout();
    textPainter.paint(canvas, new Offset((size.width - textPainter.width)/2, (size.height - textPainter.height)/2));

    //drawDebug(canvas,size);
  }
}
