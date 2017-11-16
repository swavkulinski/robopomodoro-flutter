import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:Robopomodoro/main/di/main_module.dart';
import 'package:Robopomodoro/main/dial/snapping_scroll_physics.dart';
import 'package:Robopomodoro/main/models.dart';
import 'package:Robopomodoro/main/session_state/session_state_delegate.dart';
import 'package:Robopomodoro/main/dial/session_icons_grid/widget.dart';
import 'package:Robopomodoro/main/dial/schedule_widget/widget.dart';
import 'package:Robopomodoro/main/dial/pomodoro_widget/widget.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class MainWidget extends StatelessWidget {
  final ValueChanged<bool> onTapListener;
  final SessionWidgetModel sessionWidgetModel;
  final SessionStateDelegate sessionController;
  final Size iconSize;

  MainWidget({
    Key key,
    @required this.onTapListener,
    @required this.sessionWidgetModel,
    @required this.sessionController,
    @required this.iconSize,
  }): super (key:key);
  
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var scrollController = new ScrollController();

    //session digit
    return new CustomScrollView(
      controller: scrollController,
      physics: new SnappingScrollPhysics(maxScrollOffset: size.height),
      slivers: <Widget>[
        new SliverToBoxAdapter(
            child: new Container(
                decoration: new BoxDecoration(color: PomodoroColors.white_full),
                width: size.width,
                height: size.height * 2,
                child: new Column(children: <Widget>[
                  new PomodoroWidget(
                    size: size,
                    scrollController: scrollController,
                    sessionWidgetModel: sessionWidgetModel,
                    onTapListener: onTapListener,
                  ),
                  new ScheduleWidget(
                    sessionController: sessionController,
                    sessionWidgetModel: sessionWidgetModel,
                    size: size,
                    iconSize: iconSize,
                  ),
                  new SessionIconsGrid(
                    size: size,
                    iconSize: iconSize,
                  ),
                ])))
      ],
    );
  }
}
