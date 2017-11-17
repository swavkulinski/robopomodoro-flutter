import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:Robopomodoro/main/models.dart';
import 'package:Robopomodoro/main/di/main_module.dart';
import 'package:Robopomodoro/app/models.dart';

class SectionTimer extends StatelessWidget {
  SessionWidgetModel sessionWidgetModel;

  SectionTimer({@required this.sessionWidgetModel});

  @override
  Widget build(BuildContext context) => new Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: new Text(_sectionTimeString(),
          style: sessionTimeTextStyle,
        ),
      );

  String _sectionTimeString() {

    Section section = sessionWidgetModel.session.currentSection(sessionWidgetModel.elapsedTime());
    int lengthBefore = sessionWidgetModel.totalLengthBefore(section);
    int elapsedSectionTime = sessionWidgetModel.elapsedTime() - lengthBefore;
    return sessionTimeFormat.format(new DateTime.fromMillisecondsSinceEpoch(
              section.length - elapsedSectionTime));
  }
}
