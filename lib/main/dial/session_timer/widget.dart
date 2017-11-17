import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:Robopomodoro/main/models.dart';
import 'package:Robopomodoro/main/di/main_module.dart';

class SessionTimer extends StatelessWidget {
  SessionWidgetModel sessionWidgetModel;

  SessionTimer({@required this.sessionWidgetModel});

  @override
  Widget build(BuildContext context) => new Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: new Text(
          sessionTimeFormat.format(new DateTime.fromMillisecondsSinceEpoch(
              sessionWidgetModel.totalLength() -
                  sessionWidgetModel.elapsedTime())),
          style: sessionTimeTextStyle,
        ),
      );
}
