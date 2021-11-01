import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Data/Brand.dart';
import 'package:luxury_app_pre/Management/Utils.dart';

class BrandScreen extends StatefulWidget {
  final Brand brand;
  BrandScreen(this.brand);

  @override
  _BrandScreenState createState() => _BrandScreenState(brand);
}

class _BrandScreenState extends State<BrandScreen> {
  final Brand brand;
  _BrandScreenState(this.brand);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(brand.name),
      ),
    );
  }

  Widget buildScaffold () {
    return Scaffold(
      backgroundColor: utils.resourceManager.colours.background,
      body: Stack(
        children: [

        ],
      ),
    );
  }
}
