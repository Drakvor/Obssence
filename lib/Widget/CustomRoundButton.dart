import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';

class CustomRoundButton extends StatefulWidget {
  final VoidCallback whenPressed;
  final String image;
  final String imagePressed;
  final double h;
  final double w;
  CustomRoundButton({required this.whenPressed, required this.image, required this.imagePressed, required this.h, required this.w});

  @override
  _CustomRoundButtonState createState() => _CustomRoundButtonState(whenPressed, image, imagePressed, h, w);
}

class _CustomRoundButtonState extends State<CustomRoundButton> {
  final VoidCallback whenPressed;
  final String image;
  final String imagePressed;
  final double h;
  final double w;

  bool _pressed = false;

  _CustomRoundButtonState(this.whenPressed, this.image, this.imagePressed, this.h, this.w);

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
                height: h/2,
                width: w/2,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: _pressed ? Image.asset(imagePressed) : Image.asset(image),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPressedButton (BuildContext context) {
    return Center(
      child: Container(
        height: h,
        width: w,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Image.asset(utils.resourceManager.images.roundButtonPressed),
        ),
      ),
    );
  }

  Widget buildButton (BuildContext context) {
    return Center(
      child: Container(
        height: h,
        width: w,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Image.asset(utils.resourceManager.images.roundButton),
        ),
      ),
    );
  }
}

class CustomRoundToggle extends StatefulWidget {
  final Function whenPressed;
  final String image;
  final String imagePressed;
  final double h;
  final double w;
  CustomRoundToggle({required this.whenPressed, required this.image, required this.imagePressed, required this.h, required this.w});

  @override
  _CustomRoundToggleState createState() => _CustomRoundToggleState(whenPressed, image, imagePressed, h, w);
}

class _CustomRoundToggleState extends State<CustomRoundToggle> {
  final Function whenPressed;
  final String image;
  final String imagePressed;
  final double h;
  final double w;

  bool _pressed = false;

  _CustomRoundToggleState(this.whenPressed, this.image, this.imagePressed, this.h, this.w);

  void setPressed () {
    setState(() {
      _pressed = true;
    });
  }

  @override
  Widget build (BuildContext context) {
    return GestureDetector(
      onTap: () {
        whenPressed(_pressed);
        setState(() {
          _pressed = !_pressed;
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
                height: h/2,
                width: w/2,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: _pressed ? Image.asset(imagePressed) : Image.asset(image),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPressedButton (BuildContext context) {
    return Center(
      child: Container(
        height: h,
        width: w,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Image.asset(utils.resourceManager.images.roundButtonPressed),
        ),
      ),
    );
  }

  Widget buildButton (BuildContext context) {
    return Center(
      child: Container(
        height: h,
        width: w,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Image.asset(utils.resourceManager.images.roundButton),
        ),
      ),
    );
  }
}

class CustomRoundToggled extends StatelessWidget {
  final Function whenPressed;
  final String image;
  final String imagePressed;
  final double h;
  final double w;
  final bool pressed;
  CustomRoundToggled({required this.whenPressed, required this.image, required this.imagePressed, required this.h, required this.w, this.pressed=false});

  @override
  Widget build (BuildContext context) {
    return GestureDetector(
      onTap: () {
        whenPressed();
      },
      child: Container(
        height: h,
        width: w,
        child: Stack(
          children: [
            pressed ? buildPressedButton(context) : buildButton(context),
            Center(
              child: Container(
                height: h/2,
                width: w/2,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: pressed ? Image.asset(imagePressed) : Image.asset(image),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPressedButton (BuildContext context) {
    return Center(
      child: Container(
        height: h,
        width: w,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Image.asset(utils.resourceManager.images.roundButtonPressed),
        ),
      ),
    );
  }

  Widget buildButton (BuildContext context) {
    return Center(
      child: Container(
        height: h,
        width: w,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Image.asset(utils.resourceManager.images.roundButton),
        ),
      ),
    );
  }
}
