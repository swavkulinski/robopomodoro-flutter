import 'package:flutter/widgets.dart';
import '../../di/main_module.dart';

class SessionPrompt extends StatelessWidget {

  final Size size;
  final ScrollController scrollController;

  SessionPrompt ({
    Key key,
    this.size,
    this.scrollController,
  }) :
  assert(size != null),
  assert(scrollController != null),
  super(key:key);

  @override
  Widget build(BuildContext context) => new SizedBox(
        width: size.width,
        height: size.height,
        child: new Align(
          alignment: Alignment.bottomCenter,
          child: new Padding(
            padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 50.0),
            child: new GestureDetector(
              onTap:  () => scrollController.position.animateTo(size.height,
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 300)),
              child: new Text(
                "Add sessions",
                style: defaultTextStyle,
              ),
            ),
          ),
        ),
      );

  }
 