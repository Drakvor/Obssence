import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';

class CustomScrollIndicator extends StatelessWidget {
  final int index;
  final double max;
  final String direction;
  CustomScrollIndicator(this.index, this.max, {this.direction="horizontal"});

  @override
  Widget build (BuildContext context) {
    return Container(
      child: (direction == "horizontal") ? buildRow(context) : buildColumn(context),
    );
  }

  Widget buildRow (BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: getLinesHoriz(context),
    );
  }

  List<Widget> getLinesHoriz (BuildContext context) {
    List<Widget> lines = [];
    for (int i = 0; i < max; i++) {
      lines.add((index == i) ? longSegment(context) : shortSegment(context));
    }
    return lines;
  }

  Widget longSegment (BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
      width: 40,
      height: 10,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Image.asset(utils.resourceManager.images.horizLine),
      ),
    );
  }

  Widget shortSegment (BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
      width: 20,
      height: 10,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Image.asset(utils.resourceManager.images.horizLine),
      ),
    );
  }

  Widget buildColumn (BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: getLinesVert(context),
    );
  }

  List<Widget> getLinesVert (BuildContext context) {
    List<Widget> lines = [];
    for (int i = 0; i < max; i++) {
      lines.add((index == i) ? highSegment(context) : lowSegment(context));
    }
    return lines;
  }

  Widget highSegment (BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
      height: 40,
      width: 10,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Image.asset(utils.resourceManager.images.vertLine),
      ),
    );
  }

  Widget lowSegment (BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
      height: 20,
      width: 10,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Image.asset(utils.resourceManager.images.vertLine),
      ),
    );
  }
}