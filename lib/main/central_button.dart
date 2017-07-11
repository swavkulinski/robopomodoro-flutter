import 'package:flutter/material.dart';
import 'main_module.dart';


class CentralButtonPainter extends CustomPainter {
  Paint bodyPaint;
  Paint shadowPaint;
  CentralButtonPainter(this.bodyPaint,this.shadowPaint);

  @override
  bool shouldRepaint(CentralButtonPainter old) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    print("cenntral_button size:$size");
    var rectangle = new Rect.fromCircle(center: new Offset(size.width/2,size.height/2),radius:size.width/2);
    var shadowPath = new Path();
    shadowPath.addOval(rectangle);
    canvas.drawPath(shadowPath, shadowPaint);
    canvas.drawPath(shadowPath, bodyPaint);
    //drawDebug(canvas,size);
  }
}
