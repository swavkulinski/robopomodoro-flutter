import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../di/main_module.dart';
import 'snapping_scroll_physics.dart';
import '../models.dart';
import '../session_state/session_state_delegate.dart';
import 'session_icons_grid/widget.dart';
import 'schedule_widget/widget.dart';
import 'pomodoro_widget/widget.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class DialWidget extends StatelessWidget {
  final ValueChanged<bool> onTapListener;
  final SessionWidgetModel sessionWidgetModel;
  final SessionStateDelegate sessionController;
  final Size iconSize;

  DialWidget({
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
                  //_plate(size, scrollController, sessionState),
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
