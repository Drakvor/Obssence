import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Widget/CustomInnerShadow.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback? whenPressed;
  final TextStyle style;
  final String text;
  final double h;
  final double w;

  CustomButton({this.whenPressed, this.text="", required this.style, this.h=25, this.w=100});

  @override
  _CustomButtonState createState() => _CustomButtonState(whenPressed!, text, style, h, w);
}

class _CustomButtonState extends State<CustomButton> {
  final VoidCallback whenPressed;
  final TextStyle style;
  final String text;
  final double h;
  final double w;

  bool _pressed = false;

  _CustomButtonState(this.whenPressed, this.text, this.style, this.h, this.w);

  @override
  Widget build(BuildContext context) {
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
      child: _pressed ? buildPressedButton(context) : buildButton(context),
    );
  }

  Widget buildButton (BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: h,
      width: w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(h/2),
        color: utils.resourceManager.colours.background,
        boxShadow: [
          BoxShadow(
            color: utils.resourceManager.colours.shadowDark,
            offset: Offset(6, 2),
            blurRadius: 8,
          ),
          BoxShadow(
            color: utils.resourceManager.colours.shadowLight,
            offset: Offset(-3, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRect(
        child:  BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 1, sigmaX: 1),
          child: Container(
            height: h,
            width: w,
            child: Center(
              child: Text(text, style: style,),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPressedButton (BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: h,
      width: w,
      child: InnerShadow(
        blur: 4,
        offset: Offset(-4, -2),
        color: utils.resourceManager.colours.shadowLight,
        child: InnerShadow(
          blur: 4,
          offset: Offset(4, 2),
          color: utils.resourceManager.colours.shadowDark,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(h/2),
              color: utils.resourceManager.colours.background,
            ),
            child: Container(
              child: Center(
                child: Text(text, style: style,),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDarkButton extends StatefulWidget {
  final VoidCallback? whenPressed;
  final TextStyle style;
  final String text;
  final double h;
  final double w;

  CustomDarkButton({this.whenPressed, this.text="", required this.style, this.h=25, this.w=100});

  @override
  _CustomDarkButtonState createState() => _CustomDarkButtonState(whenPressed!, text, style, h, w);
}

class _CustomDarkButtonState extends State<CustomDarkButton> {
  final VoidCallback whenPressed;
  final TextStyle style;
  final String text;
  final double h;
  final double w;

  bool _pressed = false;

  _CustomDarkButtonState(this.whenPressed, this.text, this.style, this.h, this.w);

  @override
  Widget build(BuildContext context) {
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
      child: _pressed ? buildPressedButton(context) : buildButton(context),
    );
  }

  Widget buildButton (BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: h,
      width: w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(h/2),
        color: utils.resourceManager.colours.backgroundSecond,
        boxShadow: [
          BoxShadow(
            color: utils.resourceManager.colours.shadowDarkSecond,
            offset: Offset(6, 2),
            blurRadius: 8,
          ),
          BoxShadow(
            color: utils.resourceManager.colours.shadowLightSecond,
            offset: Offset(-3, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRect(
        child:  BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 1, sigmaX: 1),
          child: Container(
            height: h,
            width: w,
            child: Center(
              child: Text(text, style: style,),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPressedButton (BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: h,
      width: w,
      child: InnerShadow(
        blur: 4,
        offset: Offset(-4, -2),
        color: utils.resourceManager.colours.shadowLightSecond,
        child: InnerShadow(
          blur: 4,
          offset: Offset(4, 2),
          color: utils.resourceManager.colours.shadowDarkSecond,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(h/2),
              color: utils.resourceManager.colours.backgroundSecond,
            ),
            child: Container(
              child: Center(
                child: Text(text, style: style,),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
