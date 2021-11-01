import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Data/Brand.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Widget/CustomInnerShadow.dart';

class BrandTile extends StatefulWidget {
  final Brand brand;
  BrandTile(this.brand);

  @override
  _BrandTileState createState() => _BrandTileState(brand);
}

class _BrandTileState extends State<BrandTile> {
  final Brand brand;
  bool pressed = false;
  _BrandTileState(this.brand);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          pressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          pressed = false;
        });
      },
      onTapUp: (TapUpDetails details) {
        setState(() {
          pressed = false;
        });
      },
      onTap: () {
        utils.appManager.toBrandPage(context, utils.pageNav, brand);
      },
      child: (pressed) ? buildPressed() : buildUnpressed(),
    );
  }

  Widget buildUnpressed () {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
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
      child: getContents(),
    );
  }

  Widget buildPressed () {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: InnerShadow(
        blur: 10,
        offset: Offset(-4, -4),
        color: utils.resourceManager.colours.shadowLight,
        child: InnerShadow(
          blur: 10,
          offset: Offset(4, 4),
          color: utils.resourceManager.colours.shadowDark,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: utils.resourceManager.colours.background,
            ),
            child: getContents(),
          ),
        ),
      ),
    );
  }

  Widget getContents () {
    return Container(
      child: Center(
        child: Text(brand.name),
      ),
    );
  }
}
