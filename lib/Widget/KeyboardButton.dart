import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';

class KeyboardButton extends StatefulWidget {
  KeyboardButton({
    Key? key,
    required this.whenPressed,
    required this.text,
    required this.style,
    required this.h,
    required this.w,
    required this.isText,
    required this.imageStr,
    this.dark = false,
  }) : super(key: key);

  final bool dark;
  final void Function(String) whenPressed;
  final TextStyle style;
  final String text;
  final double h;
  final double w;
  final bool isText;
  final String imageStr;

  @override
  _KeyboardButtonState createState() => _KeyboardButtonState();
}

class _KeyboardButtonState extends State<KeyboardButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.whenPressed(widget.text);
      },
      onTapDown: (TapDownDetails details) {
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
      child: buildButton(context),
    );
  }

  Widget buildButton (BuildContext context) {
    return Container(
      height: widget.h,
      width: widget.w,
      color: (_pressed) ? utils.resourceManager.colours.white : (widget.dark ? utils.resourceManager.colours.backgroundSecond : utils.resourceManager.colours.background),
      child: Center(
        child: widget.isText? Text(widget.text, textAlign: TextAlign.center, style: widget.dark ? utils.resourceManager.textStyles.base25white : utils.resourceManager.textStyles.base25,) : Image.asset(widget.imageStr),
      ),
    );
  }

  Widget buildSpecialButton (BuildContext context) {
    return Container(
      height: widget.h,
      width: widget.w,
      color: (_pressed) ? utils.resourceManager.colours.white : (widget.dark ? utils.resourceManager.colours.backgroundSecond : utils.resourceManager.colours.background),
      child: Center(
        child: Text(widget.text, textAlign: TextAlign.center, style: widget.dark ? utils.resourceManager.textStyles.base25white : utils.resourceManager.textStyles.base25,),
      ),
    );
  }
}