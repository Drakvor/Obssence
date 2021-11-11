import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';

class OverlayMain extends StatefulWidget {
  final double height;
  final Widget contents;
  OverlayMain(this.height, this.contents);

  @override
  _OverlayMainState createState() => _OverlayMainState();
}

class _OverlayMainState extends State<OverlayMain> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: coverScreen(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: widget.height,
            child: widget.contents,
          ),
        ],
      ),
    );
  }

  Widget coverScreen () {
    return Container();
  }
}
