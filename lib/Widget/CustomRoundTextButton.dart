import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';

class CustomRoundTextButton extends StatefulWidget {
  final VoidCallback whenPressed;
  final TextStyle style;
  final String text;
  final double h;
  final double w;
  CustomRoundTextButton({required this.whenPressed, required this.text, required this.style, required this.h, required this.w});

  @override
  _CustomRoundTextButtonState createState() => _CustomRoundTextButtonState(whenPressed, text, style, h, w);
}

class _CustomRoundTextButtonState extends State<CustomRoundTextButton> {
  final VoidCallback whenPressed;
  final TextStyle style;
  final String text;
  final double h;
  final double w;

  bool _pressed = false;

  _CustomRoundTextButtonState(this.whenPressed, this.text, this.style, this.h, this.w);

  @override
  Widget build (BuildContext context) {
    return GestureDetector(
      onTap: whenPressed,
      onTapDown: (TapDownDetails details) {
        //do something
        setState(() {
          _pressed = true;
        });
      },
      onTapUp: (TapUpDetails details) {
        setState(() {
          _pressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },
      child: Container(
        height: h,
        width: w,
        child: Stack(
          children: [
            _pressed ? buildPressedButton(context) : buildButton(context),
            Center(
              child: Container(
                height: h-20,
                width: w-20,
                child: Center(
                  child: Text(text, style: style),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPressedButton (BuildContext context) {
    return Container(
      height: h,
      width: w,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Image.asset(utils.resourceManager.images.roundButtonPressed),
      ),
    );
  }

  Widget buildButton (BuildContext context) {
    return Container(
      height: h,
      width: w,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Image.asset(utils.resourceManager.images.roundButton),
      ),
    );
  }
}
