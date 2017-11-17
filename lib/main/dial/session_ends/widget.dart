import 'package:flutter/material.dart';
import 'package:Robopomodoro/main/di/main_module.dart';

class SessionEnds extends StatelessWidget {
  final int length;
  final DateTime sessionEnds;

  const SessionEnds({Key key, this.length, this.sessionEnds})
      : assert(length != null),
        assert(sessionEnds != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var message = "";
    if (length > 0) {
      message = "Session ends ${currentTimeFormat.format(sessionEnds)}";
    }
    return new Text(
      message,
      style: currentTimeTextStyle,
    );
  }
}
