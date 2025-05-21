import 'package:flutter/material.dart';
import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
import 'package:simple_animations/animation_mixin/animation_mixin.dart';

class CustomSwitchButton2 extends StatefulWidget {
  final bool checked;

  final Color checkedColor;

  final Color unCheckedColor;

  final Duration animationDuration;

  final Color backgroundColor;

  final double buttonWidth;

  final double buttonHeight;
  final double indicatorWidth;
  final double indicatorBorderRadius;
  final double backgroundBorderRadius;

  const CustomSwitchButton2({
    super.key,
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
  });

  @override
  State<CustomSwitchButton2> createState() => _CustomSwitchButton2State();
}

class _CustomSwitchButton2State extends State<CustomSwitchButton2>
    with AnimationMixin {
  //late Animation<double> size; // Declare animation variable

  var control = Control.stop;

  double v = 0;

  @override
  void initState() {
    // v = Provider.of<LanguageViewModel>(context, listen: false)
    //             .currentLanguage ==
    //         "en"
    //     ? (widget.checked ? 20 : 0)
    //     : (widget.checked ? 0 : 20);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAnimationBuilder<double>(
      control: control, // bind variable with control instruction
      tween: Tween<double>(begin: 20.0, end: 0.0),
      duration: widget.animationDuration,
      builder: (context, value, child) {
        debugPrint("value = $value");
        if (widget.checked) {
          value = 0;

          ///for english
          if (value == 20) {
            debugPrint("im here");

            ///control = Control.playReverse;
            control = Control.playReverseFromEnd;
          }

          ///for arabic
          if (value == 0) {
            debugPrint("im here2");

            ///control = Control.playReverse;
            control = Control.playReverseFromEnd;
          }
        } else {
          control = Control.stop;
        }
        return _buildCheckbox(context, value);
      },
    );
  }

  Widget _buildCheckbox(context, animation) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        decoration: _outerBoxDecoration(widget.backgroundColor),
        width: 51.0,
        height: 31.0,
        padding: const EdgeInsets.all(3.0),
        child: Stack(
          children: [
            Positioned(
                child: Padding(
              padding: EdgeInsets.only(left: double.parse("$animation")),
              child: Container(
                width: 27.0,
                height: 27.0,
                decoration: _innerBoxDecoration(widget.unCheckedColor),
              ),
            ))
          ],
        ),
      ),
    );
  }

  BoxDecoration _innerBoxDecoration(color) => BoxDecoration(
      borderRadius:
          BorderRadius.all(Radius.circular(widget.indicatorBorderRadius)),
      color: color);

  BoxDecoration _outerBoxDecoration(color) => BoxDecoration(
        borderRadius:
            BorderRadius.all(Radius.circular(widget.backgroundBorderRadius)),
        color: widget.checked ? Colors.blue : Colors.grey[200],
      );
}
