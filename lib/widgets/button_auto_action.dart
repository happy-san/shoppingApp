import 'package:flutter/material.dart';

class AutoActionButton extends StatelessWidget {
  final double height;
  final double width;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final GestureLongPressUpCallback onLongPressUp;
  final Widget child;

  const AutoActionButton({
    @required this.height,
    @required this.width,
    @required this.onTap,
    @required this.onLongPress,
    @required this.onLongPressUp,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Material(
        color: Theme.of(context).accentColor,
        child: GestureDetector(
          onLongPress: onLongPress,
          onLongPressUp: onLongPressUp,
          child: InkWell(
            splashColor: Color.fromRGBO(255, 190, 58, 1),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            onTap: onTap,
            child: child,
          ),
        ),
        elevation: 2,
        shape: CircleBorder(),
      ),
    );
  }
}
