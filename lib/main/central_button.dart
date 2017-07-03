import 'package:flutter/material.dart';
import 'main_module.dart';

class CentralButton extends StatefulWidget {
  Size size;
  Paint bodyPaint;
  Paint shadowPaint;

  CentralButton({
    Key key,
    this.size,
    this.bodyPaint,
    this.shadowPaint,
  }): super(key: key);

  @override
  _CentralButtonState createState() => new _CentralButtonState();
}

class _CentralButtonState extends State<CentralButton> {
  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
        painter: new _CentralButtonPainter(widget.bodyPaint,widget.shadowPaint),
        size: widget.size);
  }
}

class _CentralButtonPainter extends CustomPainter {
  Paint bodyPaint;
  Paint shadowPaint;
  _CentralButtonPainter(this.bodyPaint,this.shadowPaint);

  @override
  bool shouldRepaint(_CentralButtonPainter old) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    print("cenntral_button size:$size");
    var rectangle = new Rect.fromCircle(center: new Offset(size.width/2, size.height/2),radius:size.width/2);
    var shadowPath = new Path();
    shadowPath.addOval(rectangle);
    canvas.drawOval(rectangle, shadowPaint);
    canvas.drawOval(rectangle, bodyPaint);
    drawDebug(canvas,size);
  }
}
