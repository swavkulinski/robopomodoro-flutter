import 'package:flutter/material.dart';
import '../../di/main_module.dart';

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
      //"Session ends ${currentTimeFormat.format(sessionWidgetModel.startTime.add(new Duration(milliseconds:sessionWidgetModel.totalLength())))}";
    }
    return new Text(
      message,
      style: currentTimeTextStyle,
    );
  }
}
