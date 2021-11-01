import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:luxury_app_pre/Management/Utils.dart';

class CustomDivider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: utils.resourceManager.colours.white,
          ),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: utils.resourceManager.colours.dividerBot,
          ),
        ],
      ),
    );
  }
}

class CustomDividerShort extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width-20,
            color: utils.resourceManager.colours.white,
          ),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width-20,
            color: utils.resourceManager.colours.dividerBot,
          ),
        ],
      ),
    );
  }
}

class CustomThinDivider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width-20,
            color: utils.resourceManager.colours.dividerThinTop,
          ),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width-20,
            color: utils.resourceManager.colours.dividerThinBot,
          ),
        ],
      ),
    );
  }
}

class CustomDottedDivider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 2,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: width - 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: getDots(width),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getDots (double w) {
    List<Widget> dots = [];
    for (int i = 0; i < w/5; i++) {
      dots.add(
        Container(
          height: 1,
          width: 2,
          color: Color(0xffffffff),
        ),
      );
    }
    return dots;
  }
}

class CustomDottedDividerLong extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 2,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: width - 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: getDots(width),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getDots (double w) {
    List<Widget> dots = [];
    for (int i = 0; i < w/5; i++) {
      dots.add(
        Container(
          height: 1,
          width: 2,
          color: Color(0xffffffff),
        ),
      );
    }
    return dots;
  }
}

