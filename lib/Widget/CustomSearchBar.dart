import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController textControl;
  final String hintText;

  CustomSearchBar(this.textControl, this.hintText);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState(textControl, hintText);
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController textControl;
  final String hintText;
  final FocusNode node = new FocusNode();

  _CustomSearchBarState(this.textControl, this.hintText);

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
            child: node.hasFocus ? Image.asset(utils.resourceManager.images.searchBarImage) : Image.asset(utils.resourceManager.images.searchBarImageInactive),
          ),
          Positioned(
            top: 16,
            left: 10,
            right: 10,
            bottom: 5,
            child: TextField(
              focusNode: node,
              autofocus: false,
              controller: textControl,
              cursorColor: utils.resourceManager.colours.black,
              decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: hintText,
                hintStyle: utils.resourceManager.textStyles.base13gold,
              ),
              onSubmitted: (value) {
                if (value.length < 40) {
                  utils.agentManager.setSearchString(value);
                  utils.appManager.changeState();
                  textControl.clear();
                  utils.agentManager.getAction(context);
                }
                else {
                  //notify
                }
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