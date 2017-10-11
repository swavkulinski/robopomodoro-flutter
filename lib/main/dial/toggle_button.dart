import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  final ValueChanged<bool> onStateChangeListener;
  final bool state;
  final Widget firstChild;
  final Widget secondChild;

  const ToggleButton({
    Key key,
    this.onStateChangeListener,
    this.state,
    this.firstChild,
    this.secondChild,
  }):
        assert(firstChild != null),
        assert(secondChild != null),
        super(key: key);

  Widget build(BuildContext context) {
    return new GestureDetector(onTap: () => _handleTap(), child: _stateControlledChild());
  }

  void _handleTap() {
    if (onStateChangeListener != null) {
      print("ToggleButton _handleTap");
      onStateChangeListener(!state);
    }
  }

  Widget _stateControlledChild() {
    if(state) {
      return secondChild;
    }
    return firstChild;
  }
}
