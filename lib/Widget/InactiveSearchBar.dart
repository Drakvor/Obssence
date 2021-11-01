import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';

class InactiveSearchBar extends StatelessWidget {
  final VoidCallback whenPressed;
  InactiveSearchBar(this.whenPressed);

  @override
  Widget build (BuildContext context) {
    return GestureDetector(
      onTap: whenPressed,
      child: buildBox(context),
    );
  }

  Widget buildBox (BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Stack(
        children: [
          Container(
              margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: Image.asset(utils.resourceManager.images.searchBarImageInactive)
          ),
          Container(
            margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: TextField(
              enabled: false,
              autofocus: false,
              cursorColor: utils.resourceManager.colours.black,
              decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: "Search",
              ),
            ),
          ),
        ],
      ),
    );
  }
}