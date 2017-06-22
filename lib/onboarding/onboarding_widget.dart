import 'package:flutter/material.dart';
import 'dart:math';

class OnboardingWidget extends StatefulWidget {
  OnboardingWidget({Key key, this.callback}) : super(key: key);
  final VoidCallback callback;

  @override
  _OnboardingState createState() => new _OnboardingState();
}

class _OnboardingState extends State<OnboardingWidget> {
  int _page = 0;

  static const int MAX_PAGE = 4;
  static const int MIN_PAGE = 0;

  void _nextPage() {
    setState(() {
      _page = min(++_page, MAX_PAGE);
    });
  }

  void _previousPage() {
    setState(() {
      _page = max(--_page, MIN_PAGE);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Onboarding'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'You have pushed the button this many times:',
              ),
              new Text(
                '$_page',
                style: Theme.of(context).textTheme.display1,
              ),
            ],
          ),
        ),
        floatingActionButton: new FloatingActionButton(
            child: new Icon(Icons.add),
            onPressed: () {
              widget.callback();
              Navigator.of(context).pushReplacementNamed('/home');
            }));
  }
}
