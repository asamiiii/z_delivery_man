import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

import '../../styles/color.dart';

class CustomSwitchButton extends StatelessWidget {
  final bool? checked;
  Key? key;
  final Color checkedColor;

  final Color unCheckedColor;

  final Duration animationDuration;

  final Color backgroundColor;

  final double buttonWidth;

  final double buttonHeight;
  final double indicatorWidth;
  final double indicatorBorderRadius;
  final double backgroundBorderRadius;

  CustomSwitchButton({
    Key? key,
    required this.backgroundColor,
    required this.checked,
    required this.checkedColor,
    required this.unCheckedColor,
    required this.animationDuration,
    this.buttonWidth = 40,
    this.buttonHeight = 20,
    this.indicatorWidth = 13,
    this.indicatorBorderRadius = 25,
    this.backgroundBorderRadius = 30,
  })  : assert(animationDuration != null),
        assert(unCheckedColor != null),
        assert(backgroundColor != null),
        assert(checkedColor != null),
        assert(checked != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // var tween = MultiTween([
    //   Track("paddingLeft").add(animationDuration, Tween(begin: 0.0, end: 20.0)),
    //   Track("color").add(animationDuration,
    //       ColorTween(begin: unCheckedColor, end: checkedColor)),
    // ]);

    // return ControlledAnimation(
    //   playback: checked
    //       // && provider.currentLanguage == "en"
    //       ? Playback.PLAY_FORWARD
    //       : Playback.PLAY_REVERSE,
    //   startPosition: checked ? 1.0 : 0.0,
    //   duration: tween.duration * 1.2,
    //   tween: tween,
    //   curve: Curves.easeInOut,
    //   builder: _buildCheckbox,
    // );
    return const SizedBox();
  }

  Widget _buildCheckbox(context, animation) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        decoration: _outerBoxDecoration(backgroundColor),
        width: 51.0,
        height: 31.0,
        padding: const EdgeInsets.all(3.0),
        child: Stack(
          children: [
            Positioned(
                child: Padding(
              padding: EdgeInsets.only(left: animation["paddingLeft"]),
              child: Container(
                width: 27.0,
                height: 27.0,
                decoration: _innerBoxDecoration(animation["color"]),
              ),
            ))
          ],
        ),
      ),
    );
  }

  BoxDecoration _innerBoxDecoration(color) => BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(indicatorBorderRadius)),
      color: color);

  BoxDecoration _outerBoxDecoration(color) => BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(backgroundBorderRadius)),
        color: checked! ? primaryColor : Colors.grey[200],
      );
}
