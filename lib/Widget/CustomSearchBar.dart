import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';

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
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: node.hasFocus ? Image.asset(utils.resourceManager.images.searchBarImage) : Image.asset(utils.resourceManager.images.searchBarImageInactive),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
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
        ],
      ),
    );
  }
}