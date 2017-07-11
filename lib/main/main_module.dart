import 'package:flutter/material.dart';

TextStyle centralButtonStyle() => new TextStyle(
      color: new Color(0xFFFFFFFF),
      fontSize: 40.0,

    );

Paint defaultPaint() {
    var paint = new Paint();
    paint.color = defaultDialColor();
    return paint;
  }

Paint defaultShadowPaint() {
      var paint = new Paint();
      paint.color = new Color(0x66000000);
      paint.maskFilter = new MaskFilter.blur(BlurStyle.normal, 2.0);
      return paint;
}


Color defaultDialColor() => new Color(0xFFA4C639);

void drawDebug(Canvas canvas, Size size) {
    var increment = 20.0;
    Paint debugPaint = new Paint();
    debugPaint.color = new Color(0xFF000000);
    for(var x = 0.0; x < size.width; x+=increment) {
      canvas.drawLine(new Offset(x,0.0), new Offset(x,size.height), debugPaint);
    }
    for(var y = 0.0; y < size.height; y+=increment) {
      canvas.drawLine(new Offset(0.0,y), new Offset(size.width,y), debugPaint);
    }
}
