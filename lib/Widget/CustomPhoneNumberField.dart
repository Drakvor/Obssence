import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';

class CustomPhoneNumberField extends StatefulWidget {
  final TextEditingController textControl;
  final String hintText;
  final FocusNode node;
  final Function setActive;

  CustomPhoneNumberField(this.textControl, this.hintText, this.node, this.setActive);

  @override
  _CustomPhoneNumberFieldState createState() => _CustomPhoneNumberFieldState(textControl, hintText, node);
}

class _CustomPhoneNumberFieldState extends State<CustomPhoneNumberField> {
  final TextEditingController textControl;
  final String hintText;
  final FocusNode node;

  _CustomPhoneNumberFieldState(this.textControl, this.hintText, this.node);

  @override
  Widget build (BuildContext context) {
    return buildBox(context);
  }

  Widget buildBox (BuildContext context) {
    return Container(
      width: 300,
      height: 40,
      child: Stack(
        children: [
          Center(
            child: node.hasFocus ? Image.asset(utils.resourceManager.images.phoneNumberField) : Image.asset(utils.resourceManager.images.phoneNumberFieldInactive),
          ),
          Positioned(
            top: 5,
            left: 8,
            bottom: 5,
            width: 30,
            child: Image.asset(utils.resourceManager.images.flag),
          ),
          Positioned(
            top: 5,
            left: 40,
            bottom: 5,
            width: 30,
            child: Center(
              child: Text("+82"),
            ),
          ),
          Positioned(
            top: 16,
            left: 80,
            right: 10,
            bottom: 5,
            child: TextField(
              focusNode: node,
              keyboardType: TextInputType.none,
              autofocus: false,
              controller: textControl,
              cursorColor: utils.resourceManager.colours.black,
              style: utils.resourceManager.textStyles.base13,
              decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: hintText,
                hintStyle: utils.resourceManager.textStyles.base13gold,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(node);
                widget.setActive();
              },
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            bottom: 5,
            width: 30,
            child: CustomRoundButton(
              whenPressed: () {
                print("hi");
                textControl.clear();
              },
              image: utils.resourceManager.images.closeButton,
              imagePressed: utils.resourceManager.images.closeButton,
              w: 30,
              h: 30,
            ),
          ),
        ],
      ),
    );
  }
}